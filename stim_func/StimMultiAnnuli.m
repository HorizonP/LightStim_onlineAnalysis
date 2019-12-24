function StimMultiAnnuli(ringsMat,flipSecs,stim_contrast,options)
% generate spot for precise duration, but not for precise onset timing
% options(1): NoKeyWait, options(2): gapless
global param_screen 
struct2vars(param_screen)

%=== units conversion
ringsIRPix=ringsMat(:,1)*umTopix;
ringsORPix=ringsMat(:,2)*umTopix; % radius(um) to diameter(pix) 
intensity=screen_w*stim_contrast;
waitframes = round(flipSecs / ifi);
posX=xCen+ringsMat(:,3)*umTopix;
posY=yCen+ringsMat(:,4)*umTopix;
rects=[posX-ringsORPix posY-ringsORPix posX+ringsORPix posY+ringsORPix]';
thicknesses=ringsORPix-ringsIRPix;
%===

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    kbstate=kbContinue;
    if kbstate==0
        return
    end
end
%===
% sendComment(['(auto) MultiAnnulus: r=(' num2str(ringIR) ',' num2str(ringOR) ')(um), contrast=' num2str(stim_contrast)],4,{num2str(ringIR)})

Screen('FrameOval', screen_win, intensity ,rects,thicknesses);
Screen('CopyWindow',screen_win,screen_win_off);

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