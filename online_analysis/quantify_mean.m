function [on_mean,off_mean] = quantify_mean(obj,varargin)
    % on_mean time window: the duration of stimulus ON shifted by a delay
    % off_mean time window: a window follow on_mean time window with the
    % same length
    
    %default
    delay=0.05; 
    bool_offset_immediate_baseline=true;
    imbl=[-0.08 0.02];
    bool_manual_ON_duration=false;
    bool_manual_OFF_duration=false;
    sign_reverse=false;
    if ~isempty(varargin)
        opts=varargin{1};
        if isfield(opts,'delay')
            delay=opts.delay;
        end
        if isfield(opts,'ON_duration')
            bool_manual_ON_duration=true;
        end
        if isfield(opts,'OFF_duration')
            bool_manual_OFF_duration=true;
        end
        if isfield(opts,'offset_immediate_baseline')
            bool_offset_immediate_baseline=opts.offset_immediate_baseline;
        end
        if isfield(opts,'immediate_baseline')&& ~isempty(opts.immediate_baseline)
            imbl=opts.immediate_baseline;
        end
        if isfield(opts,'sign_reverse')
            sign_reverse=opts.sign_reverse;
        end
    end
    
    delay_Tn=round(delay*obj.tickrate);
    ind_mat=[obj.ascendT(:), obj.descendT(:), obj.descendT(:)+1, 2*obj.descendT(:)-obj.ascendT(:)+1] +delay_Tn;
    if bool_manual_ON_duration
        ON_duration_Tn=round(opts.ON_duration * obj.tickrate);
        ind_mat(:,2)=obj.ascendT(:)+ON_duration_Tn;
    end
    if bool_manual_OFF_duration
        OFF_duration_Tn=round(opts.OFF_duration * obj.tickrate);
        ind_mat(:,4)=obj.ascendT(:)+OFF_duration_Tn;
    end
    
    on_mean=[];off_mean=[];
    for i=1:length(obj.ascendT(:))
        on_mean=[on_mean mean(obj.Reschan(ind_mat(i,1):ind_mat(i,2)))];
        off_mean=[off_mean mean(obj.Reschan(ind_mat(i,3):ind_mat(i,4)))];
    end
    if bool_offset_immediate_baseline
        immed_base_ind=obj.ascendT'+(imbl(1)*obj.tickrate:imbl(2)*obj.tickrate); 
        immed_base=mean(obj.Reschan(immed_base_ind),2)';
        on_mean=on_mean-immed_base;
        off_mean=off_mean-immed_base;
    end
    
    if sign_reverse
        on_mean=-on_mean;
        off_mean=-off_mean;
    end

end