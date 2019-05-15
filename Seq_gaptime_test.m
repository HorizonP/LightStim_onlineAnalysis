spotR=[50];
flipSecs=0.5;
stim_contrast=1;

gapTime=[5 3 2 1 0.5 0.5 1 2 3 5 10 0];

%% ===============Routine===============

x_axis=[];



exit=false;
for i=1:length(gapTime)         
    StimSpot(spotR,flipSecs,stim_contrast);
    exit=GapTime(gapTime(i));
    if exit
        break
    end
    x_axis(i)=spotR;
end


%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']),'spotR','flipSecs','stim_contrast','gapTime');