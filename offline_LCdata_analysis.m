%% add current LabChart selection to data collection LCAcoll
LCAcoll(length(LCAcoll)+1)=LCAnalysis;
LCAcoll(end)
%% single data x-y plot
n=length(LCAcoll)

quant_opts=[];
[on,off]=quantify_mean(LCAcoll(n),quant_opts);

LCAcoll(n).analysis_res=on;
% LCAcoll(n).analysis_res=off;
plot(LCAcoll(n).x_axis,LCAcoll(n).analysis_res,'Marker','*')



function plot_x_y(x_axis,res,ax)
if ~exist('ax','var')||isempty(ax)
    f=figure;
    ax=axes(f);
end

[x_consolidated,~,subs]=unique(x_axis);
res_consolidated=accumarray(subs,res,[],@mean);

plot(ax,x_consolidated,res_consolidated)
end

