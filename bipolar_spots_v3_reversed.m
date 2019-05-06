spotsR=[12.5 25 50 100 150 300 600]; % in um, not pixel
spotsR=fliplr(spotsR)
stim_contrast=0;
flipSec = 3;


WaitSecs(0.10);
for i=1:length(spotsR)         
    [secs, keyCode, deltaSecs]=KbWait;
    if keyCode(41)==1 || keyCode(27)==1 %ESC is pressed
        break
    else
        StimSpot(param_screen,spotsR(i),flipSec,stim_contrast)
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));