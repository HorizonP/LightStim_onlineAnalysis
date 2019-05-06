%===============Params=====================================================
stim_contrast=1

spotsR=[25 50 25];
spotsR=[25 600 25];
spotsR=[100 600 100];
spotsR=[50 600 50];
% % % 
spotsR=[600 25 600];
spotsR=[600 50 600];
spotsR=[600 100 600];

% spotsR=[1:0.1:2]*100
spotsR=[600 100 600]
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

WaitSecs(0.15);
[~, keyCode, ~]=KbWait;
if keyCode(41)~=1 && keyCode(27)~=1 %ESC is not pressed
    for i=1:length(flipSecs)
        StimSpot(param_screen,spotsR(i),flipSecs(i),stim_contrast,[0,1])
    end
    Screen('flip',param_screen.screen_win)
end


%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
% save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));