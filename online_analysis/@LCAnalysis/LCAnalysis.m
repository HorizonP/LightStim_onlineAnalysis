classdef LCAnalysis < handle
    % A class for online analysis of LabChart data
    
    properties 
        LCDoc_h % the handle of corresponding LCDoc (temporary valid)
        selection % TODO: the reference to corresponding selection in the original file
        tickrate % sampling frequency of labchart data
        selectedChans % the channel numbers of selected channels (1-based)
        selectedData % the data returned by LabChart
        Reschan % data of response, default is the first column of selectedData
        TTLchan % data of TTL channel
        x_axis % the x axis for x-y plot
        analysis_res % store the y data for x-y plot

        low_pass % params of filter, will set by 'apply_filter' and 'restore_filter', if empty suggests not done yet
        corr_bl_method % the method used for baseline correction (see 'corr_bl'), if empty suggests not done yet

    end
    properties (Dependent) % see the corresponding get function for each variable
        T % time axis
        digitized_TTLchan % TTLchan(TTLchan<0.5)=0; TTLchan(TTLchan>=0.5)=1;
        ascendT % the indexes of data points where TTL is ascending
        descendT % the indexes of data points where TTL is descending
        derivative % derivative of Reschan

    end
    properties (Hidden)
        %param
        tickrate_raw %to store original tickrate if decimated
        bl_polypara % polynomial fit parameter of baseline
        stim_name_verbose % store the whole string of stim part from interpreted filename
    end

    
    methods
        % initiation
        function obj=LCAnalysis(varargin)
            % extract useful information from LCDoc_h for analysis, as the
            % selection of LCDoc_h could change later
            
            %=== default values
            TTL_chan_number=5;
            decimation=5; % if obj.tickrate<1e4, decimation=1
            %===
            
            %=== input interpret
            if isempty(varargin) % use gLCDoc
                global gLCDoc
                if ~gLCDoc.isinterface
                    restartLC();
                end
                LCDoc_h=gLCDoc;
                display(['LCAnalysis: ' LCDoc_h.Name])
            else
                LCDoc_h=varargin{1};
            end
            obj.LCDoc_h=LCDoc_h; %$ save reference to the LCDoc
            %===
            
            %=== set tickrate
            % check if tickrate is the same
            blocks=LCDoc_h.SelectionStartRecord : LCDoc_h.SelectionEndRecord;
            lcTick=@LCDoc_h.GetRecordSecsPerTick;
            assert(length(unique(arrayfun(lcTick,blocks)))==1,'tickrate for each block is different')
            
            obj.tickrate=round(1/lcTick(LCDoc_h.SelectionEndRecord)); %$ assign tickrate
            obj.tickrate_raw=obj.tickrate; % backup for decimation
            if obj.tickrate<1e4
                decimation=1;
                disp(['tickrate is ' num2str(obj.tickrate) ', disabled decimation'])
            end
            %===
            
            %=== select TTL channel as well if not selected
            chan_bool=selectedChanNumber(LCDoc_h);
            if ~chan_bool(TTL_chan_number) % TTL channel isn't selected
                LCDoc_h.SelectChannel(TTL_chan_number-1,true) % select TTL channel
                chan_bool=selectedChanNumber(LCDoc_h);
            end
            tmp=1:length(chan_bool); obj.selectedChans=tmp(chan_bool); %$
            %===
            
            %=== data process (decimation, scale)
            obj.selectedData=LCDoc_h.GetSelectedData(1,-1)'; %$ return as matrix not cell array, only include channels selected       
            % decimation process
            if decimation>1
                obj.selectedData=squeeze(mean(reshape(obj.selectedData,size(obj.selectedData,1),decimation,[]),2));
                obj.tickrate=obj.tickrate/decimation;
            end
            
            % set the scales and create Reschan
            ResUnit=LCDoc_h.GetUnits(obj.selectedChans(1)-1,LCDoc_h.SelectionEndRecord);
%             if strcmp(ResUnit,'pA')
%                 disp('LCAnalysis: Reschan processed as current response')
%                 obj.Reschan=obj.selectedData(1,:)*current_chan_scale;
%             elseif strcmp(ResUnit,'mV')
%                 disp('LCAnalysis: Reschan processed as voltage response')
%                 obj.Reschan=obj.selectedData(1,:)*vodltage_chan_scale;
%             else
%                 disp('LCAnalysis: Reschan stays raw')
%                 obj.Reschan=obj.selectedData(1,:);
%             end
            obj.Reschan=obj.selectedData(1,:);
            obj.TTLchan=obj.selectedData(obj.selectedChans==TTL_chan_number,:); %$
            %===
            
            
            %=== set x_axis
%             global x_axis
%             if ~isempty(x_axis)
%                 obj.x_axis=x_axis;
%             end
            obj.setXFromDatapad();
            %===
            
            %=== get basic info of selection
            obj.selection=selectionInfo(LCDoc_h);
            %===
            

        end

        % dependent function
        function val=get.digitized_TTLchan(obj)
            val=obj.TTLchan;
            val(obj.TTLchan<0.5)=0; val(obj.TTLchan>=0.5)=1;
        end
        function val=get.T(obj)
            val=(1:length(obj.Reschan))/obj.tickrate;
        end
        function val=get.ascendT(obj)
            val=find([0 obj.digitized_TTLchan(1:end-1)]==0&obj.digitized_TTLchan==1);
        end
        function val=get.descendT(obj)
            val=find(obj.digitized_TTLchan==1&[obj.digitized_TTLchan(2:end) 0]==0);
        end
        
        function setXFromDatapad(obj)
            doc=obj.LCDoc_h;
            col=5; % the column number in labchart datapad
            assert(strcmp('Extract Numbers in Comment Text',doc.GetDataPadColumnFuncName(col)));
            getVal=@(row) doc.GetDataPadValue(1,row,col);
            
            row_offset=4; % first data in datapad is in row #5
            obj.x_axis=arrayfun(getVal,[1:length(obj.ascendT)]+row_offset); 
            if any(isnan(obj.x_axis))
                warning('x_axis set from Datapad has problem')
            end
        end
        function resetSelection(obj)
            setSelection(obj.LCDoc_h,obj.selection);
        end

        
        % preprocessing: low-pass filter & baseline correction
        function apply_filter(obj,hd,low_pass)
            
            if ~isempty(obj.low_pass) % if obj.Reschan was filtered
                if low_pass==obj.low_pass %no need to filter again
                    return
                end
                % if the previous filter is different from the one to apply
                % restore chan2
                bl=polyval(obj.bl_polypara,obj.T);
                obj.chan2=obj.chan2_raw-bl; %$
            end
            % to apply filter on chan2 and chan5
            obj.chan2=filter(hd,obj.chan2); 
            obj.chan5=filter(hd,obj.chan5_raw);
            obj.chan5(obj.chan5<0.5)=0; obj.chan5(obj.chan5>=0.5)=1;
            obj.low_pass=low_pass;
        end
        function corr_bl(obj,met)
            % corr_bl(obj,met)
            % default to correct baseline for 10mV recording 
            % can also correct baseline by old method when new_met=false.
            % modify: obj.corr_bl_method, obj.bl_polypara, obj.chan2

            
            
            % datamask: all light on and 2s after light off is 1, other is 0
            datamask=obj.chan5;
            datamask(reshape(obj.descendT'+(0:2*obj.tickrate),1,[]))=1;
            if strcmp(met,'polynomial')
                disp('correct baseline by old method')
                obj.corr_bl_method='polynomial';
                polypara=polyfit(obj.T(logical(~datamask)),obj.chan2_raw(logical(~datamask)),10); % p is fitted on ~datamask

            elseif strcmp(met,'movmin-median')
                disp('correct baseline by new method')
                obj.corr_bl_method='movmin-median';
                % Generate baseline by new method
                n=1000; window=6;

                decimate= @(sig) median(reshape(sig (1:(length(sig)-mod(length(sig),n)) ),n,[])); %decimate by median value
                T_dm=decimate(obj.T);
                chan2_dm=decimate(obj.chan2_raw);
                datamask_dm=any(reshape(datamask (1:(length(datamask)-mod(length(datamask),n))) ,n,[]));

                T_dm_mk=T_dm(logical(~datamask_dm));
                chan2_dm_mk=chan2_dm(logical(~datamask_dm));

                polypara=polyfit(T_dm_mk,movmin(chan2_dm_mk,window),10);

            elseif strcmp(met,'detrend')
                disp('correct baseline by detrend')
                obj.corr_bl_method='detrend';
                
                polypara=polyfit(obj.T(logical(~datamask)),obj.chan2_raw(logical(~datamask)),1);
            else
                disp('wrong argument, did not corrected baseline')
                polypara=[];

            end
            obj.bl_polypara=polypara; %$
            bl=polyval(polypara,obj.T);

            obj.chan2=obj.chan2_raw-bl; %$

        end
        function restore_filter(obj)
            if ~isempty(obj.bl_polypara)
                bl=polyval(obj.bl_polypara,obj.T);
                obj.chan2=obj.chan2_raw-bl;
            else
                obj.chan2=obj.chan2_raw;
            end
            obj.chan5(obj.chan5_raw<0.5)=0; obj.chan5(obj.chan5_raw>=0.5)=1;
            obj.low_pass=[];
        end
        function clear_preprocessing(obj)
            obj.chan2=obj.chan2_raw;
            chan5_=obj.chan5_raw;
            chan5_(chan5_<0.5)=0; chan5_(chan5_>=0.5)=1;
            obj.chan5=chan5_;
            obj.low_pass=[];
            obj.bl_polypara=[];
        end

        sli=slicing(obj,prev_on,after_off)
        fig=plot_in_panels(obj,prev_on,after_off,opts)
        
        % Visualization
        function [fig,pline]=plot(obj,ax,include_median,stim_ind_color) 
            % for visualizing the Reschan data with stimulus indicator
            % if given ax, then draw on the ax; if not, draw on a new
            % figure. if include_median is fed by 'true', then draw median
            % filter on the data
            
            if ~exist('ax','var') || isempty(ax)
                fig=figure; 
                fig.Name=obj.filename;
                ax=gca;
            end
            if ~exist('include_median','var') || isempty(include_median)
                include_median=false;
            end
            if ~exist('stim_ind_color','var') || isempty(stim_ind_color)
                colors='y';
            else
                colors=stim_ind_color;
            end
            hold(ax,'on');
            pline=plot(ax,obj.T,obj.Reschan);

            SAClip.stim_indicator(ax,obj.ascendT/obj.tickrate,obj.descendT/obj.tickrate,colors)
            
            if include_median~=false
                plot(ax,obj.T,movmedian(obj.Reschan,2000));
            end
            title(ax,disp_name(obj),'Interpreter','none');
            xlim(ax,[0,obj.T(end)]);
            hold(ax,'off');
            
        end
        
        % data analysis function
        function [ind,time]=spikeCount(obj,thre)
            if ~exist('thre','var')||isempty(thre) % if no argument fed to this function, use the 3*std as default threshold
                thre=3*std(obj.derivative);
            end
            [~,ind]=findpeaks(obj.derivative,'MinPeakHeight',thre);
            time=obj.T(ind);
        end
        function freq=point_wise_freq(obj,win_duration,spikeTn)
            % a moving window method of counting spike histogram
            if ~exist('spikeTn','var')||isempty(spikeTn)
                spikeTn=obj.spikeCount();
            end
            T=obj.T;
            win_size=win_duration*obj.tickrate;
            win_size=win_size-(1-mod(win_size,2));
            freq=zeros(size(T));
            for i=1:length(T)
                b=i-(win_size-1)/2; % the index of beginning of window
                e=i+(win_size-1)/2; % the index of end of window

                % truncate window at beginning and end of chan2
                if b<1
                    b=1;
                end
                if e>length(T)
                    e=length(T);
                end

                freq(i)=length(find(spikeTn>=b&spikeTn<=e))/(T(e)-T(b));

            end
        end
        function [on_peak,off_peak,on_peak_t,off_peak_t] = quantify_exc_input_normal(obj,ifbaseoff)
            % quantify excitatory input by finding the maximum of
            % Reschan immediately after onset and offset
            % of stimulus
            % depolarizing input is positive
            trace=obj.Reschan;
            base_ind=obj.ascendT'+(-0.58*obj.tickrate:0.02*obj.tickrate); 
            base=mean(trace(base_ind),2);
            baseoff_ind=obj.descendT'+(-0.1*obj.tickrate:0.02*obj.tickrate);
            baseoff=mean(trace(baseoff_ind),2);

            on_ind=obj.ascendT'+(0:0.3*obj.tickrate);
            on_depolar=(-trace(on_ind)+base);
            [~,I]=max(abs(on_depolar)'); %#ok<UDIM>
            on_peak=on_depolar(sub2ind(size(on_depolar),1:length(I),I));
            on_peak_t=I/obj.tickrate; % relative to stimulus onset
            % figure;plot(on_peak_t,on_peak)

            off_ind=obj.descendT'+(0:0.3*obj.tickrate);
            if ifbaseoff
                off_depolar=(-trace(off_ind)+baseoff);
            else
                off_depolar=(-trace(off_ind)+base);
            end
            [~,I]=max(abs(off_depolar)'); %#ok<UDIM>
            off_peak=off_depolar(sub2ind(size(off_depolar),1:length(I),I));
            off_peak_t=I/obj.tickrate; % relative to stimulus offset
            % figure;plot(off_peak_t,off_peak)
            
        end
        [on_peak,off_peak,on_peak_t,off_peak_t] = quantify_exc_input_median(obj)
        function [on_peak,off_peak,on_peak_t,off_peak_t] = quantify_inh_input_median(obj)
            trace=movmedian(obj.Reschan,2000);
            base_ind=obj.ascendT'+(-0.08*obj.tickrate:0.02*obj.tickrate); 
            base=mean(trace(base_ind),2);

            on_ind=obj.ascendT'+(0:0.5*obj.tickrate);
            on_relative=trace(on_ind)-base;
            [~,I]=max(abs(on_relative)'); %#ok<UDIM>
            on_peak=on_relative(sub2ind(size(on_relative),1:length(I),I));
            on_peak_t=I/obj.tickrate; % relative to stimulus onset
            % figure;plot(on_peak_t,on_peak)

            off_ind=obj.descendT'+(0:0.5*obj.tickrate);
            off_relative=trace(off_ind)-base;
            [~,I]=max(abs(off_relative)'); %#ok<UDIM>
            off_peak=off_relative(sub2ind(size(off_relative),1:length(I),I));
            off_peak_t=I/obj.tickrate; % relative to stimulus offset
            % figure;plot(off_peak_t,off_peak)
        end      
        function [on_recepf,off_recepf] = quantify_inh_input_mean(obj)
            
            %default
            delay=0.1; 

            % create chan5_stair
            tmp=zeros(size(obj.chan5));
            tmp(obj.ascendT)=1;
            tmpp=cumsum(tmp); % figure;plot(T,tmpp)
            chan5_stair=tmpp.*logical(obj.chan5); % figure;scatter(T,chan5_stair)

            on_ttl=circshift(chan5_stair,delay*obj.tickrate); % delay 100ms to count response
            off_ttl=circshift(chan5_stair,(1+delay)*obj.tickrate); % for same length of interval of stimulus on

            tmp=accumarray(on_ttl'+1,obj.Reschan',[],@mean);
            on_recepf=tmp(2:end)';
            tmp=accumarray(off_ttl'+1,obj.Reschan',[],@mean);
            off_recepf=tmp(2:end)';
            
            obj.ReceptiveField=[on_recepf;off_recepf];

        end
    end

    
    methods (Static)
        hd=standardFilter(varargin);
        slope=difftor_mex(data,tickrate,win_size);
        slope=difftor(data,tickrate,win_size);
        stim_indicator(ax,x_starts,x_ends,colors);
        function thre=threshold_of_derivative(derivative)
            thre=3*std(derivative);
        end
        function thre=alter_threshold_of_derivative(derivative)
            deriv_gmm=fitgmdist(derivative',2);
            [~,I]=max(deriv_gmm.ComponentProportion);
            thre=deriv_gmm.mu(I)+4*sqrt(deriv_gmm.Sigma(I));
        end 

        
    end
end