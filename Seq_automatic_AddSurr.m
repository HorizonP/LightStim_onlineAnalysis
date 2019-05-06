spotsR=[50 100 600];
% spotsR=[100 100 150 200:100:800 100 50]
flipSecs=1;

stim_contrast=1;
repeatN=4;
gapTime=3;


%% ===============Routine===============
[a,b,c]=meshgrid(spotsR,flipSecs,stim_contrast);
spotsR=a(:)';
flipSecs=b(:)';
stim_contrast=c(:)';


WaitSecs(0.15);
exit=false;
for j=1:repeatN
    for i=1:length(spotsR)         
        StimGaplessSpots(param_screen,spotsR,flipSecs,1)
        exit=GapTime(gapTime);
        if exit
            break
        end
    end
    if exit
        break
    end
end