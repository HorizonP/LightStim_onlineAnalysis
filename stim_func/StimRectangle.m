function StimRectangle(length_height_posX_posY,flipSecs,stim_contrast,options)
% generate Rectangle for precise duration, but not for precise onset timing
global param_screen
struct2vars(param_screen);

l_h=length_height_posX_posY(1:2)*umTopix;
posX=length_height_posX_posY(3)*umTopix;
posY=length_height_posX_posY(4)*umTopix;

rect=[0 0 l_h];
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

Screen('FillRect', screen_win, intensity ,CenterRectOnPoint(rect,xCen+posX,yCen+posY));
Screen('CopyWindow',screen_win,screen_win_off); % for gapless
vbl = Screen('Flip', screen_win);
io64(ttlObj,57600,1);
% to display information to console
intensity_length_height_posX_posY_flipSec=[stim_contrast,length_height_posX_posY,flipSecs]
comment=['(auto) Rectangle: x-width, y-width, Xoffset, Yoffset=' num2str(l_h(1)) ', ' num2str(l_h(2)) ', ' num2str(posX) ', ' num2str(posY) ', contrast=' num2str(stim_contrast)];
sendComment(comment, 4)
if exist('options','var') && length(options)>=2 && options(2)==1
    %=== gapless
    Screen('drawTexture',screen_win,screen_win_off)
    Screen('Flip', screen_win, vbl + (waitframe - 0.5 -1) * ifi); %
else
    Screen('Flip', screen_win, vbl + (waitframe - 0.5) * ifi); %
end
io64(ttlObj,57600,0);
end