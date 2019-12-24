ringsOR=[100 150 200 250 300 350 400 450 500 600 700 800]; %um
ringsIR=[ 50 100 150 200 250 300 350 400 450 550 650 750]; %um
center_spot_r=75; %um % I should also test 75

stimDuration=[0.5 1 0.5];

stim_contrast=1;
repeatN=1;
gapTime=5;

% % longer duration
% ringsOR=[300 400];
% ringsIR=[250 350];
% flipSecs=3;

disp(['total time would be: ' num2str(repeatN* length(ringsIR)*(sum(stimDuration)+gapTime)) 's'])
sendComment('Seq_Auto_ringsAddToCenterRF',-1)
x_axis=[];

WaitSecs(0.15);
exit=false;

for j=1:repeatN
    order=randperm(length(ringsOR)); % randomize the sequence
    ringsOR=ringsOR(order);
    ringsIR=ringsIR(order);
    
    for i=1:length(ringsOR)
        sendComment(['(auto) ring[r=(' num2str(ringsIR(i)) ', ' num2str(ringsOR(i)) ')(um)] added to center(r=' num2str(center_spot_r) 'um), contrast=' num2str(stim_contrast)],4);
        StimSpot(center_spot_r,stimDuration(1),stim_contrast,[0,1,1]);
        StimMultiAnnuli([0,center_spot_r,0,0;ringsIR(i),ringsOR(i),0,0],stimDuration(2),stim_contrast,[0,1]);
        StimSpot(center_spot_r,stimDuration(3),stim_contrast,[0,0,1]);
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