function stim_indicator(ax,x_starts,x_ends,colors)
% create the yellow bar for stimulus indicator
% x_starts: an array contains start x value for every indicators
% x_ends: an array contains end x value for every indicators
% colors: an cell array contains ColorSpec for each indicator

if ischar(colors) || (ismatrix(colors) && length(colors)==3)
    tmp=cell(1,length(x_starts));
    tmp(:)={colors};
    colors=tmp;
end
held=ishold(ax);
hold(ax,'on')
for i=1:length(x_starts)
    yl=ylim(ax);
    xs=x_starts(i);
    xe=x_ends(i);
    light=fill(ax,[xs,xe,xe,xs],repelem(yl,2),colors{i});    
    alpha(light,0.3);
    light.LineStyle='none';
    if length(ax.Children)>1
        ax.Children=ax.Children([end 1:end-1]); % move the indicator (last one) background
    end
    set(light,'HandleVisibility','off')    
end

if ~held
    hold(ax,'off')
end
end
