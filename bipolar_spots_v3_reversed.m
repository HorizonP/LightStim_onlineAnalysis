spotsR=[12.5 25 50 100 150 300 600]; % in um, not pixel
spotsR=fliplr(spotsR)

% for online data analysis
global x_axis
x_axis=spotsR;

stim_contrast=1;
flipSec = 3;


sendComment(['bipolar_spots_v3_reversed, contrast=' num2str(stim_contrast)],-1);
for i=1:length(spotsR)         
    kbstate=kbContinue;
    if kbstate==0 %ESC is pressed
        break
    else
        
        StimSpot(spotsR(i),flipSec,stim_contrast)
        
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));