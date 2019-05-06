
ringsOR=[25 50 100 150 200 250 300 350 400 450 500]; %um
ringsIR=[ 0 25  50 100 150 200 250 300 350 400 450]; %um
order=randperm(length(ringsOR))
ringsOR=ringsOR(order);
ringsIR=ringsIR(order);
flipSecs=0.5;

stim_contrast=1;
repeatN=2;
gapTime=2;
disp(['total time would be: ' num2str(repeatN* length(spotsR)*(flipSecs+gapTime)) 's'])


WaitSecs(0.15);
exit=false;
for j=1:repeatN
    for i=1:length(ringsOR)         
        StimAnnulus(param_screen,ringsIR(i),ringsOR(i),flipSecs,stim_contrast);
        exit=GapTime(gapTime);
        if exit
            break
        end
    end
    if exit
        break
    end
end