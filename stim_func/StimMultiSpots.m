function StimMultiSpots(param_screen,spotsMat,flipSecs,stim_contrast,options)
% generate spot for precise duration, but not for precise onset timing
% options(1): NoKeyWait, options(2): gapless
tic
struct2vars(param_screen)

%=== units conversion
spotRPix=spotsMat(:,1)*umTopix; % radius(um) to diameter(pix) 
intensity=screen_w*stim_contrast;
waitframes = round(flipSecs / ifi);
posX=xCen+spotsMat(:,2)*umTopix;
posY=yCen+spotsMat(:,3)*umTopix;
rects=[posX-spotRPix posY-spotRPix posX+spotRPix posY+spotRPix]';
%===

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    kbstate=kbContinue;
    if kbstate==0
        return
    end
end
%===

Screen('FillOval', screen_win, intensity ,rects);
Screen('CopyWindow',screen_win,screen_win_off);
toc
vbl = Screen('Flip', screen_win);
io64(ttlObj,57600,1);


if exist('options','var') && length(options)>=2 && options(2)==1
    %=== gapless
    Screen('drawTexture',screen_win,screen_win_off)
    Screen('Flip', screen_win, vbl + (waitframes - 0.5 -1) * ifi); %
else
    Screen('Flip', screen_win, vbl + (waitframes - 0.5) * ifi); %
end
io64(ttlObj,57600,0);
% end