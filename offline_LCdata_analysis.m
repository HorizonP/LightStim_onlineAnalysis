%% add current LabChart selection to data collection LCAcoll
LCAcoll(length(LCAcoll)+1)=LCAnalysis;
LCAcoll(end)
% x_axis would be wrong if the selection is not most recent stimuli tested
%% compute analysis_res
n=length(LCAcoll)

quant_opts=[];
[on,off]=quantify_mean(LCAcoll(n),quant_opts);
LCAcoll(n).analysis_res=on;
% LCAcoll(n).analysis_res=off;
%% plot_T_Response
plot_T_Response(LCAcoll(n));

%% plot_X_Response
plot_X_Response(LCAcoll(n));




%%
function plot_x_y(x_axis,res,ax)
if ~exist('ax','var')||isempty(ax)
    f=figure;
    ax=axes(f);
end

[x_consolidated,~,subs]=unique(x_axis);
res_consolidated=accumarray(subs,res(:),[],@mean);

plot(ax,x_consolidated,res_consolidated,'Marker','*')
end

