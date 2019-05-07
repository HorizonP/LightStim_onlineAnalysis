function [fig, scal_bar]=plot_in_panels(obj,prev_on,after_off,opts)
    strc=obj.slicing(prev_on,after_off);
    
    %=== defaults & optional params
    fig_width=1000;
    fig_height=150;
    marg_h=0.05;
    marg_w=0.05;
    gap=0.02;
    indicator_bar_color='y';
    select_res=1:size(strc.response_arr,1);
    if exist('opts','var') && ~isempty(opts)
        if isfield(opts,'reverse_order') && opts.reverse_order
            disp([obj.filename 'plot in reversed order'])
            strc.response_arr=flipud(strc.response_arr);
        end
        if isfield(opts,'fig_width')
            fig_width=opts.fig_width;
        end
        if isfield(opts,'fig_height')
            fig_height=opts.fig_height;
        end      
        if isfield(opts,'gap')
            gap=opts.gap;
        end
        if isfield(opts,'marg_h')
            marg_h=opts.marg_h;
        end 
        if isfield(opts,'marg_w')
            marg_w=opts.marg_w;
        end
        if isfield(opts,'indicator_bar_color')
            indicator_bar_color=opts.indicator_bar_color;
        end        
        if isfield(opts,'select_res') % only plot selected response in panels
            select_res=opts.select_res;
    end
    %===
    
    fig=figure('Name',obj.filename,'NumberTitle','off');
    col_n=length(select_res);
    g_arr=tight_subplot(1,col_n,gap,marg_h,marg_w);
    for i=1:col_n
        y=strc.response_arr(select_res(i),:);
        plot(g_arr(i),strc.t_axis,y,'LineWidth',0.01);
        xlim(g_arr(i),[strc.t_axis(1) strc.t_axis(end)])
        box(g_arr(i),'off'); axis(g_arr(i),'off')
    end
    linkaxes(g_arr(1:col_n),'xy')
    
    % draw light indicator
    light_on_sec=0;
    light_off_sec=strc.stim_duration;
    for i=1:col_n
        stim_indicator(g_arr(i),light_on_sec,light_off_sec,indicator_bar_color)
    end
    
    % draw scale_bar on the first axes
    scal_bar=scalebar(g_arr(1)); 
    scal_bar.YLen=10; scal_bar.YUnit='pA'; scal_bar.XLen=1; scal_bar.XUnit='s';
    
    fig.UserData=scal_bar;
    fig.Position([3 4])=[fig_width fig_height];
    mtit(fig,obj.filename,'Interpreter','none') % add title for the figure
end