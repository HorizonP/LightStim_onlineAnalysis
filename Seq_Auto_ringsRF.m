
ringsOR=[25 50 100 150 200 250 300 350 400 450 500]; %um
ringsIR=[ 0 25  50 100 150 200 250 300 350 400 450]; %um
order=randperm(length(ringsOR))
ringsOR=ringsOR(order);
ringsIR=ringsIR(order);

flipSecs=1;

stim_contrast=1;
repeatN=2;
gapTime=5;
disp(['total time would be: ' num2str(repeatN* length(spotsR)*(flipSecs+gapTime)) 's'])


x_axis=[];

WaitSecs(0.15);
exit=false;
for j=1:repeatN
    for i=1:length(ringsOR)         
        StimAnnulus(ringsIR(i),ringsOR(i),flipSecs,stim_contrast);
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