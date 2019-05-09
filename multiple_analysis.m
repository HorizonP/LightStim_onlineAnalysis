%%
figure; hold on
plot(LCAcoll(1).x_axis,LCAcoll(1).analysis_res)
plot(LCAcoll(2).x_axis,LCAcoll(2).analysis_res)
%%
plot_x_y([LCAcoll(1).x_axis LCAcoll(2).x_axis],[LCAcoll(1).analysis_res LCAcoll(2).analysis_res],gca)


function plot_x_y(x_axis,res,ax)
if ~exist('ax','var')||isempty(ax)
    f=figure;
    ax=axes(f);
end

[x_consolidated,~,subs]=unique(x_axis);
res_consolidated=accumarray(subs,res,[],@mean);

plot(ax,x_consolidated,res_consolidated)
end