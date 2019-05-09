setup_screen(0.3);
% setup_screen(0.3);
%%
sca

%% adptation version of flickering stim
r=50; f=4;
adpt_contrast=0.5;
adpt_time=5;
flicker_t=10;
% StimSpot(r,adpt_time,adpt_contrast,[0 1])
StimSineModulatedSpot( r, flicker_t, f)
%% flickering stim
StimSineModulatedSpot( 300, 10, 1)


%%
% StimSpot(spotR,flipSecs,stim_contrast,options(keywait,gapless))
StimSpot(50,3,1,1);
StimSpot(600,3,1,1);
% StimSpot(1200,3,1);
%%
StimMultiSpots([50 75 0],2,1)
%%
StimRollingSector(30,100,500,5,1)
%% prsent displaced spots during center spot
StimMultiSpots([50 0 0],0.5,1,[1,1])
StimMultiSpots([50 0 0; 50 150 0],2,1,[0,1])
StimMultiSpots([50 0 0],0.5,1,[0,0])
%%
% StimMultiSpots(spotsMat,flipSecs,stim_contrast,NoKeyWait)
StimMultiSpots([50 100 0],3,1)
%%
StimRectangle([14400 14400 0 0],10,0)
%%
StimSpot(50,3,1,1);

%%
repeatN=100;
gapTime=15;

exit=false;
for j=1:repeatN       
    %======
    StimGaplessSpots([100 600 100],[1 2 1],1)
    if GapTime(gapTime)
        break
    end
    
    %======
    StimSpot(50,1,1,1)
     if GapTime(gapTime)
        break
    end
end