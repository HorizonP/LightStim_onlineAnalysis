param_screen=setup_screen(0.3);
% param_screen=setup_screen(0.3);
%%
sca

%% adptation version of flickering stim
r=50; f=4;
adpt_contrast=0.5;
adpt_time=5;
flicker_t=10;
% StimSpot(param_screen,r,adpt_time,adpt_contrast,[0 1])
StimSineModulatedSpot(param_screen, r, flicker_t, f)
%% flickering stim
StimSineModulatedSpot(param_screen, 300, 10, 1)


%%
% StimSpot(param_screen,spotR,flipSecs,stim_contrast,options(keywait,gapless))
StimSpot(param_screen,50,3,1,1);
StimSpot(param_screen,600,3,1,1);
% StimSpot(param_screen,1200,3,1);
%%
StimMultiSpots(param_screen,[50 75 0],2,1)
%%
StimRollingSector(param_screen,30,100,500,5,1)
%% prsent displaced spots during center spot
StimMultiSpots(param_screen,[50 0 0],0.5,1,[1,1])
StimMultiSpots(param_screen,[50 0 0; 50 150 0],2,1,[0,1])
StimMultiSpots(param_screen,[50 0 0],0.5,1,[0,0])
%%
% StimMultiSpots(param_screen,spotsMat,flipSecs,stim_contrast,NoKeyWait)
StimMultiSpots(param_screen,[50 100 0],3,1)
%%
StimRectangle(param_screen,[14400 14400 0 0],10,0)
%%
StimSpot(param_screen,50,3,1,1);

%%
repeatN=100;
gapTime=15;

exit=false;
for j=1:repeatN       
    %======
    StimGaplessSpots(param_screen,[100 600 100],[1 2 1],1)
    if GapTime(gapTime)
        break
    end
    
    %======
    StimSpot(param_screen,50,1,1,1)
     if GapTime(gapTime)
        break
    end
end