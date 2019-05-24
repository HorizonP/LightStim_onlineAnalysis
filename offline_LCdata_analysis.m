%% add current LabChart selection to data collection LCAcoll
LCAcoll(length(LCAcoll)+1)=LCAnalysis;
LCAcoll(end)
% x_axis would be wrong if the selection is not most recent stimuli tested
%% compute analysis_res
n=length(LCAcoll)
% n=4
quant_opts=[];
quant_opts.delay=0.1;  %0.05;
quant_opts.sign_reverse=false;
quant_opts.immediate_baseline=[-0.4 0.1];
[on,off]=quantify_mean(LCAcoll(n),quant_opts);
% LCAcoll(n).analysis_res=on;
LCAcoll(n).analysis_res=off;
%% plot_T_Response
plot_T_Response(LCAcoll(n));
%% plot_X_Response
plot_X_Response(LCAcoll(n));
%% plot_V_Response
plot_V_Response(LCAcoll(n));



%%
LCAcoll=LCAnalysis.empty();

