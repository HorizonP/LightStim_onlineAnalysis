spotsR=[50 100 600];
% spotsR=spotsR(randperm(length(spotsR)))
% spotsR=[100 100 150 200:100:800 100 50]
flipSecs=2;
% intensity=[0.75 0.45 0.85 0.5 0.95 0.55 0.4 1 0.6 0.8];
stim_contrast=1;
repeatN=70;
% gapTime=flipSecs;
gapTime=7;

%% ===============Routine===============
% [a,b,c]=meshgrid(spotsR,flipSecs,stim_contrast);
% spotsR=a(:)';
% flipSecs=b(:)';
% stim_contrast=c(:)';

disp(['total time would be: ' num2str(repeatN* length(spotsR)*(flipSecs+gapTime)) 's'])

x_axis=[];
WaitSecs(0.15);
exit=false;
for j=1:repeatN
    for i=1:length(spotsR)         
        StimSpot(spotsR(i),flipSecs,stim_contrast);
        exit=GapTime(gapTime);
        if exit
            break
        end
        x_axis=[x_axis spotsR(i)];
    end
    if exit
        break
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']),'x_axis','spotsR','flipSecs','stim_contrast','repeatN','gapTime');