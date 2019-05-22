function StimAnnulus(ringIR,ringOR,flipSec,stim_contrast,options)
% generate spot for precise duration, but not for precise onset timing
% options(1): NoKeyWait, options(2): gapless

global param_screen
struct2vars(param_screen)

outerDia=ringOR*2*umTopix;
rect=[0 0 outerDia outerDia];
thickness=(ringOR-ringIR)*umTopix;
waitframe = round(flipSec / ifi);
intensity=screen_w*stim_contrast;

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    kbstate=kbContinue;
    if kbstate==0
        return
    end
end
%===
Screen('FrameOval',screen_win,intensity,CenterRectOnPoint(rect,xCen,yCen),thickness);
Screen('CopyWindow',screen_win,screen_win_off); % for gapless
vbl = Screen('Flip', screen_win);
io64(ttlObj,57600,1);
%===
% to display information to console
intensity_IR_OR_flipSec=[stim_contrast,ringIR,ringOR,flipSec] 
% to send comment to LabChart
sendComment(['(auto) Annulus: r=(' num2str(ringIR) ',' num2str(ringOR) ')(um), contrast=' num2str(stim_contrast)],4,{num2str(ringIR)})
%===
if exist('options','var') && length(options)>=2 && options(2)==1
    %=== gapless
    Screen('drawTexture',screen_win,screen_win_off)
    Screen('Flip', screen_win, vbl + (waitframe - 0.5 -1) * ifi); %
else
    Screen('Flip', screen_win, vbl + (waitframe - 0.5) * ifi); %
end
io64(ttlObj,57600,0);
end