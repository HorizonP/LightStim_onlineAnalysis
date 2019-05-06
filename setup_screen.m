function param_screen=setup_screen(bg_contrast)
sca;
Screen('Preference', 'SkipSyncTests', 2); % to avoid sync failure error
Screen('Preference', 'VisualDebuglevel', 3); 
% screens = Screen('Screens');
% screenNumber = max(screens);
screenNumber = 2;

screen_w = WhiteIndex(screenNumber);
screen_b = BlackIndex(screenNumber);
%=============== screen background, pixel size, and center position
background=screen_w*bg_contrast;
umTopix=ret_umTopix;
[xCen,yCen]=retCenter;
%=============== setup TTL trigger
ttlObj=io64;
stat=io64(ttlObj);
if stat
    error('Error occured in initializing TTL communication')
end
%===============
WaitSecs(1e-4); % to load the mex file of waitsecs

io64(ttlObj,57600,0); 
[screen_win, ~] = PsychImaging('OpenWindow', screenNumber, background);
Screen('Flip', screen_win); % to get a more accurate timing of screen onset

for j=1:3 % create a unique TTL train to indicate screen with background color onset
    io64(ttlObj,57600,1);
    WaitSecs(1e-3);
    io64(ttlObj,57600,0);
    WaitSecs(1e-3);
end

[screen_win_off,~]=Screen('OpenOffscreenWindow',screenNumber);

% Retreive the maximum priority number and set max priority
topPriorityLevel = MaxPriority(screen_win);
Priority(topPriorityLevel);
ifi = Screen('GetFlipInterval', screen_win);

param_screen=struct();

param_screen.ttlObj=ttlObj;
param_screen.screen_w=screen_w;
param_screen.screen_b=screen_b;
param_screen.umTopix=umTopix;
param_screen.ifi=ifi;
param_screen.screen_win=screen_win;
param_screen.bg_contrast=bg_contrast;
param_screen.xCen=xCen;
param_screen.yCen=yCen;
param_screen.screen_win_off=screen_win_off;

end