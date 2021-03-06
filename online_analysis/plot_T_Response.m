function plot_T_Response(varargin)
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

t_axi=[];x_axi=[];y_axi=[];
if length(obj)>1
    warning('plot_T_Response: plotting multiple LCAnalysis')
end
for i=1:length(obj)
    t=obj(i).ascendT/obj(i).tickrate;
    x=obj(i).x_axis;
    y=obj(i).analysis_res;
    
    if length(x)~=length(y)
        warning(['plot_T_Response: length of x_axis(' num2str(length(x)) ') does not match length of y_axis(' num2str(length(y)) '), modified x_axis to accommodate y_axis'])
        % if len(x)>len(y), rep=1, the following expression still valid
        rep=idivide(int16(length(y)),int16(length(x)),'ceil');
        x=repmat(x,rep,1);
        x=x(1:length(y));
    end
    t_axi=[t_axi t(:)'];
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
plotXY(ax,t_axi,y_axi,x_axi);
p_lines=ax.Children;
for i=1:length(p_lines)
    p_lines(i).DisplayName=['x=' num2str(p_lines(i).UserData)];
end
legend(ax);

%%
function plot_t_res(ax,t,x,y)
    t=t(:);x=x(:);y=y(:);
    
    %=== exceptions handling
    assert(length(t)==length(y),['plot_T_Response: length of t_axis(' num2str(length(t)) ')  does not match length of y_axis(' num2str(length(y)) ')'] )
    if length(x)~=length(y)
        warning(['plot_T_Response: length of x_axis(' num2str(length(x)) ') does not match length of y_axis(' num2str(length(y)) '), modified x_axis to accommodate y_axis'])
        % if len(x)>len(y), rep=1, the following expression still valid
        rep=idivide(int16(length(y)),int16(length(x)),'ceil');
        x=repmat(x,rep,1);
        x=x(1:length(y));
    end
    %===
    
    [uni,~,subs]=unique(x);
    hold(ax,'on');
    for i=1:length(uni)
        plot(ax,t(subs==i),y(subs==i),...
            'DisplayName',['x=' num2str(uni(i))],'Marker','o')

    end
    legend 
end
end