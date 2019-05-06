function StimSineModulatedSpot(param_screen,spotR,flipSec,freq,options)

struct2vars(param_screen)

frames=round(flipSec/ifi);
ti=(0:frames-1)*ifi;



% figure;plot(ti,stim_contrasts)

spotDiaPix=spotR*2*umTopix;
rect=[0 0 spotDiaPix spotDiaPix];
waitframe = 1; %round(flipSecs / ifi);

stim_contrasts=0.5*sin(2*pi*freq*ti)+0.5; % range 0~1
intensity=screen_w*stim_contrasts;
[~,ind]=findpeaks(intensity);TTL=zeros([1,length(intensity)]);TTL(ind)=1;

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    kbstate=kbContinue;
    if kbstate==0
        return
    end
end
%===


vbl = Screen('Flip', screen_win);
for i=1:length(ti)
% io64(ttlObj,57600,0); ;
Screen('FillOval', screen_win, intensity(i) ,CenterRectOnPoint(rect,xCen,yCen));
Screen('Flip', screen_win, vbl + (waitframe - 0.5) * ifi);
lptwrite(57600, TTL(i));
end
Screen('Flip', screen_win);
io64(ttlObj,57600,0);
end