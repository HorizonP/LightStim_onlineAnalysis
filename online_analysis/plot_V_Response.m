function plot_V_Response(varargin)
% assume channel #4 is the voltage channel

%% interpret inputs
lca_ind=strcmp('LCAnalysis',cellfun(@class,varargin,'UniformOutput',false));
axes_ind=strcmp('matlab.graphics.axis.Axes',cellfun(@class,varargin,'UniformOutput',false));
if any(lca_ind) % any input is LCAnalysis object
% if the obj span multiple blocks, there will be problem for the t_axis, as
% it won't capture the gap time between blocks
    obj=[varargin{lca_ind}];
    if any(axes_ind)
        ax=varargin{find(axes_ind,1)}; % use the first axes object in the inputs
    else
        figure;
        ax=axes();
    end
else
    error('plot_T_Response: wrong input');
end


%% prepare inputs for plotXY

v_axi=[];x_axi=[];y_axi=[];
if length(obj)>1
    warning('plot_V_Response: plotting multiple LCAnalysis')
end
for i=1:length(obj)
    % create TTL_stair
    assert(any(obj(i).selectedChans==4),'did not select voltage channel data')
    tmp=zeros(size(obj(i).digitized_TTLchan));
    tmp(obj(i).ascendT)=1;
    tmpp=cumsum(tmp); % integral of tmp, create a multiple-stairs curve for the TTL channel
    TTL_stair=tmpp .* obj(i).digitized_TTLchan; % only if TTL==1, TTL_stair equals to some number other than 0
    
    subs=TTL_stair'+1;
    vals=obj(i).selectedData(obj(i).selectedChans==4,:)'; % the voltage channel
    tmp=accumarray(subs,vals,[],@mean); % the mean voltage for each TTL high region, ordered by occurence (time)
    v=round(tmp(2:end)'); % a list of voltage for each TTL high region, tmp(1) is the average of voltage(TTL_stair==0), discard
    
    x=obj(i).x_axis;
    y=obj(i).analysis_res;  
    if length(x)~=length(y)
        warning(['plot_T_Response: length of x_axis(' num2str(length(x)) ') does not match length of y_axis(' num2str(length(y)) '), modified x_axis to accommodate y_axis'])
        % if len(x)>len(y), rep=1, the following expression still valid
        rep=idivide(int16(length(y)),int16(length(x)),'ceil');
        x=repmat(x,rep,1);
        x=x(1:length(y));
    end
    
    v_axi=[v_axi v(:)'];
    x_axi=[x_axi x(:)'];
    y_axi=[y_axi y(:)'];
end
%% call worker function and finalize figure
% plot_t_res(ax,t_axi,x_axi,y_axi)

% plotXY(ax,t_axi,y_axi,x_axi);
% x_uni=unique(x_axi);
% x_strings=arrayfun(@num2str,x_uni,'UniformOutput',false)';
% legend(strcat(repmat({'x='},length(x_strings),1),x_strings)')


% the method of adding legend here is error-prone for plotting on existing
% axes
plotXY(ax,v_axi,y_axi,x_axi);
p_lines=ax.Children;
for i=1:length(p_lines)
    p_lines(i).DisplayName=['x=' num2str(p_lines(i).UserData)];
end
legend(ax);


end