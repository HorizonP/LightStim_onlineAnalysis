%===========Setup==========================================================
sca; close all; clearvars;
Screen('Preference', 'SkipSyncTests', 2); % to avoid sync failure error
Screen('Preference', 'VisualDebuglevel', 3); 
screens = Screen('Screens');
screenNumber = max(screens);

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[xCen,yCen]=retCenter();
umTopix=0.3484;

%===============Params=====================================================

spotsR=[25 50 25];
spotsR=[25 600 25];
spotsR=[100 600 100];
spotsR=[50 600 50];
% % % 
spotsR=[600 25 600];
spotsR=[600 50 600];
spotsR=[600 100 600];

spotsR=[1:0.1:2]*100

flipSecs= [1];
%=======
% spotsR=[100 600];
% flipSecs= [0.05 0.95];
% % flipSecs= [0.1 0.9];
% flipSecs= [0.15 0.85];
% flipSecs= [0.2 0.8];
% flipSecs= [0.25 0.75];

if length(flipSecs)==1
    flipSecs=ones(size(spotsR))*flipSecs;
end
%===============Routine====================================================
if length(flipSecs)==1
    flipSecs=flipSecs*ones(size(spotsR));
end
spotsDiaPix=spotsR*2*umTopix; % in pixel
lptwrite(57600, 0);

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);
% Retreive the maximum priority number and set max priority
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
% Here we use to a waitframes number greater then 1 to flip at a rate not
% equal to the monitors refreash rate. For this example, once per second,
% to the nearest frame
waitframes = [1 round(flipSecs / ifi)];

[secs, keyCode, deltaSecs]=KbWait;
vbl = Screen('Flip', window);
for i=1:length(spotsDiaPix)         
    spotsDia=spotsDiaPix(i);
    Screen('FillOval', window, white ,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
    lptwrite(57600, 0);
    vbl = Screen('Flip', window, vbl + (waitframes(i) - 0.5) * ifi); %
    lptwrite(57600, 1);
    Radius_Secs=[spotsR(i),flipSecs(i)]
end
% lptwrite(57600, 0);
Screen('Flip', window, vbl + (waitframes(i+1) - 0.5) * ifi)
% lptwrite(57600, 1);
lptwrite(57600, 0);
% time=vbl-vbl
sca;

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
% save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));