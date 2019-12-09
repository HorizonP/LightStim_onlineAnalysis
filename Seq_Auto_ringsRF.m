% ringsOR=[25 50 100 150 200 250 300 350 400 450 500]; %um
ringsOR=[25 50 100 150 200 250 300 350 400 450 500 600 ]; %um
% ringsIR=repmat(100,1,ringsOR);
ringsIR=[ 0 25  50 100 150 200 250 300 350 400 450 550]; %um


flipSecs=1;

stim_contrast=1;
repeatN=1;
gapTime=5;

% % longer duration
% ringsOR=[300 400];
% ringsIR=[250 350];
% flipSecs=3;

disp(['total time would be: ' num2str(repeatN* length(spotsR)*(flipSecs+gapTime)) 's'])
x_axis=[];

WaitSecs(0.15);
exit=false;
for j=1:repeatN
    order=randperm(length(ringsOR)); % randomize the sequence
    ringsOR=ringsOR(order);
    ringsIR=ringsIR(order);
    
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