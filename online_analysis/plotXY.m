function ax=plotXY(ax,x_axis,y_axis,category)
% plot the x-y data plot on axes 'ax' by category
% Firstly, data with the same category value would be categorized into same
% group. Then, y data with the same x value would be averaged to obtain 
% final y data. The corresponding category value would be saved to UserData
% of each line objects

%=== exceptions handling
assert(length(x_axis)==length(y_axis))
assert(length(x_axis)==length(category))
if length(x_axis)~=length(y_axis)
    warning(['length of x_axis(' num2str(length(x_axis)) ') does not match length of y_axis(' num2str(length(y_axis)) '), repeated or truncated x_axis to accommodate y_axis'])
    % if len(x)>len(y), rep=1, the following expression still valid
    rep=idivide(int16(length(y_axis)),int16(length(x_axis)),'ceil'); % calculate repeat times
    x_axis=repmat(x_axis,rep,1);
    x_axis=x_axis(1:length(y_axis));
end
%===

[cates,~,subsForCates]=unique(category);

for i=1:length(cates)
    x_axis_cate=x_axis(subsForCates==i);
    y_axis_cate=y_axis(subsForCates==i);
    [x_consolidated,~,subs]=unique(x_axis_cate); % here the x_consolidated is sorted as well
    y_consolidated=accumarray(subs,y_axis_cate(:),[],@mean); % y data with the same x value would be averaged
    hold(ax,'on');
    p=plot(ax,x_consolidated,y_consolidated,'Marker','*');
    p.UserData=cates(i); % provide a cue for later adding legend
end
end

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