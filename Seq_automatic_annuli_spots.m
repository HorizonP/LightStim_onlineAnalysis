
ringsOR=[12.5 50 150 600 600]; %um
ringsIR=[   0  0   0   0 200]; %um


flipSecs=1;

stim_contrast=1;
repeatN=70;
gapTime=5;
disp(['total time would be: ' num2str(repeatN* length(spotsR)*(flipSecs+gapTime)) 's'])


x_axis=[];

WaitSecs(0.15);
exit=false;
for j=1:repeatN
    for i=1:length(ringsOR)
        if ringsIR(i)==0
            StimSpot(ringsOR(i),flipSecs,stim_contrast);
        else
            StimAnnulus(ringsIR(i),ringsOR(i),flipSecs,stim_contrast);
        end
        exit=GapTime(gapTime);
        if exit
            break
        end
        x_axis=[x_axis ringsIR(i)]; % to reflect authentic x_axis in the case of interupted sequence
    end
    if exit
        break
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']),'x_axis','ringsIR','ringsOR','flipSecs','stim_contrast','repeatN','gapTime');