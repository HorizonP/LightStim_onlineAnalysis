function plot_X_Response(varargin)
%% interpret inputs
lca_ind=strcmp('LCAnalysis',cellfun(@class,varargin,'UniformOutput',false));
axes_ind=strcmp('matlab.graphics.axis.Axes',cellfun(@class,varargin,'UniformOutput',false));
if any(lca_ind) % any input is LCAnalysis object

    obj=[varargin{lca_ind}];
    if any(axes_ind)
        ax=varargin{find(axes_ind,1)}; % use the first axes object in the inputs
    else
        figure;
        ax=axes();
    end
else
    error('plot_X_Response: wrong input');
end


%% prepare inputs for plotXY
x_axi=[];y_axi=[];
if length(obj)>1
    warning('plot_X_Response: plotting multiple LCAnalysis')
end
for i=1:length(obj)
    x=obj(i).x_axis;
    y=obj(i).analysis_res;
    if length(x)~=length(y)
        warning(['plot_X_Response: length of x_axis(' num2str(length(x)) ') does not match length of y_axis(' num2str(length(y)) '), modified x_axis to accommodate y_axis'])
        % if len(x)>len(y), rep=1, the following expression still valid
        rep=idivide(int16(length(y)),int16(length(x)),'ceil');
        x=repmat(x,rep,1);
        x=x(1:length(y));
    end
    x_axi=[x_axi x(:)'];
    y_axi=[y_axi y(:)'];
end


%% call plotXY
plotXY(ax,x_axi,y_axi,zeros(size(x_axi)));
% plot_x_y(ax,x_axi,y_axi);


%%
function plot_x_y(ax,x_axis,res)
    %=== exceptions handling
    if length(x_axis)~=length(res)
        warning(['plot_X_Response: length of x_axis(' num2str(length(x_axis)) ') does not match length of y_axis(' num2str(length(res)) '), modified x_axis to accommodate y_axis'])
        % if len(x)>len(y), rep=1, the following expression still valid
        rep=idivide(int16(length(res)),int16(length(x_axis)),'ceil');
        x_axis=repmat(x_axis,rep,1);
        x_axis=x_axis(1:length(res));
    end
    %===
    [x_consolidated,~,subs]=unique(x_axis); % here the x_consolidated is sorted as well
    res_consolidated=accumarray(subs,res(:),[],@mean);
    hold(ax,'on');
    plot(ax,x_consolidated,res_consolidated,'Marker','*')
end

end