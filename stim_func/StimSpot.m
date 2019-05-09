function StimSpot(spotR,flipSecs,stim_contrast,options)
% generate spot for precise duration, but not for precise onset timing
global param_screen
struct2vars(param_screen)

spotDiaPix=spotR*2*umTopix;
rect=[0 0 spotDiaPix spotDiaPix];
waitframe = round(flipSecs / ifi);
intensity=screen_w*stim_contrast;

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    kbstate=kbContinue;
    if kbstate==0
        return
    end
end
%===

Screen('FillOval', screen_win, intensity ,CenterRectOnPoint(rect,xCen,yCen));
Screen('CopyWindow',screen_win,screen_win_off); % for gapless
vbl = Screen('Flip', screen_win);
io64(ttlObj,57600,1);

%===
% to display information to console
intensity_spotR_flipSec=[stim_contrast,spotR,flipSecs]
% to send comment to LabChart
sendComment(['(auto) Spot: r=' num2str(spotR) 'um, contrast=' num2str(stim_contrast)],4)
% parfeval(@sendComment,0,['(auto) Spot: r=' num2str(spotR) 'um, contrast=' num2str(stim_contrast)],4);
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