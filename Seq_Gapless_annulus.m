%===============Params=====================================================
% specification of *ringsR*: two-row matrix, first row represent outer radius
% in micron, the second row represent inner radius in micron; each column
% represent an annulus

%======= Annuli: single one
% ringsR=[300;100];
% flipSecs= [3];

% ringsR=[300 600 300; 100 100 100];
% flipSecs= [0.03 1 1];
% 
% %======= Spots: Werblin's stimulus
% ringsR=[25 50 25; 0 0 0];
% ringsR=[25 600 25; 0 0 0];
% ringsR=[100 800 100; 0 0 0];
% ringsR=[50 600 50; 0 0 0];
% 
% ringsR=[600 25 600; 0 0 0];
% ringsR=[600 50 600; 0 0 0];
% ringsR=[600 100 600; 0 0 0];
% 
% ringsR=[100 600 100; 0 0 0];
% flipSecs= [1 3 1];

% ringsOR=ringsR(1,:); ringsIR=ringsR(2,:);
%======= Spots: delayed surround
ringsOR=[1000 1000];
ringsIR=[0  100];

flipSecs= [3 2];
% flipSecs= [4 2];
% flipSecs= [1 2];
% flipSecs= [0.05 3];
% flipSecs= [0.1 3];
% flipSecs= [0.15 3];
% flipSecs= [0.2 3];
% % flipSecs= [0.3 3];
% flipSecs= [0.5 3];
% flipSecs= [0.75 3];
% flipSecs= [1 3];


%===============Routine====================================================
state=kbContinue;
if state~=0 %ESC is not pressed
    for i=1:length(flipSecs)
        StimAnnulus(ringsIR(i),ringsOR(i),flipSecs(i),stim_contrast,[0,1])
    end
    Screen('flip',param_screen.screen_win)
end


%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
% save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));