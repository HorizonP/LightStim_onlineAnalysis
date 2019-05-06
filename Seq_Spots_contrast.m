%===============Params=====================================================
stim_contrast = [1 0.8 0.7 0.6 0.5 0.4 0];
stim_contrast=fliplr(stim_contrast);
flipSecs = 3;
spotsR = 50;
%% ===============Routine===============
% [a,b]=meshgrid(flipSecs,spotsR);
% spotsR=b(:)';
% flipSecs=a(:)';


WaitSecs(0.15);
for i=1:length(stim_contrast)         
    [~, keyCode, ~]=KbWait;
    if keyCode(41)==1 || keyCode(27)==1 %ESC is pressed
        break
    else
        StimSpot(param_screen,spotsR,flipSecs,stim_contrast(i))
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
% save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));