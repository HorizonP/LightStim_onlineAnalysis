function plot_T_Response(varargin)


if length(varargin)==1 && strcmp(class(varargin{1}),'LCAnalysis')
% if the obj span multiple blocks, there will be problem for the t_axis, as
% it won't capture the gap time between blocks
    obj=varargin{1};
    plot_t_res(obj.ascendT/obj.tickrate,obj.x_axis,obj.analysis_res);
else
    error('plot_T_Response: wrong input');
end


function plot_t_res(t,x,y)
    [uni,~,subs]=unique(x);
    figure; hold on
    for i=1:length(uni)
        plot(t(subs==i),y(subs==i),...
            'DisplayName',['x=' num2str(uni(i))],'Marker','o')

    end
    legend 
end
end