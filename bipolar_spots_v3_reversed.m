spotsR=[12.5 25 50 100 150 300 600]; % in um, not pixel
spotsR=fliplr(spotsR)
stim_contrast=1;
flipSec = 3;



for i=1:length(spotsR)         
    kbstate=kbContinue;
    if kbstate==0 %ESC is pressed
        break
    else
        StimSpot(param_screen,spotsR(i),flipSec,stim_contrast)
        
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));