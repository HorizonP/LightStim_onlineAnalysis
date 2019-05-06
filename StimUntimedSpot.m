function StimUntimedSpot(param_screen,spotR,stim_contrast)

struct2vars(param_screen)

spotDiaPix=spotR*2*umTopix;
rect=[0 0 spotDiaPix spotDiaPix];
intensity=screen_w*stim_contrast;

Screen('FillOval', screen_win, intensity ,CenterRectOnPoint(rect,xCen,yCen));
vbl0 = Screen('Flip', screen_win);
lptwrite(57600, 1);
intensity_spotR=[stim_contrast,spotR] % to display information to console

WaitSecs(0.15);
KbWait;

vbl1=Screen('Flip', screen_win); %
lptwrite(57600, 0);

time=vbl1-vbl0
end
