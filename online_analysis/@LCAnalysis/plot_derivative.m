function fig=plot_derivative(dtst,thre)
tickrate=dtst.tickrate;
chan2_crbl=dtst.chan2;
T=dtst.T;

if ~exist('thre','var') || isempty(thre)
    thre=3*std(dtst.derivative);
elseif ischar(thre)
    if thre=='alter'
        thre=SAClip.alter_threshold_of_derivative(dtst.derivative);
    else
        thre=3*std(dtst.derivative);
    end
end

fig=figure; 
ax=tight_subplot(2,1);
linkaxes(ax,'x');

dtst.plot(ax(1));

plot(ax(2),T,dtst.derivative);
hold(ax(2),'on');
plot(ax(2),[0 T(end)],thre*[1 1]); 
plot(ax(2),[0 T(end)],[0 0]);
plot(ax(2),[0 T(end)],thre*[-1 -1]); 

end