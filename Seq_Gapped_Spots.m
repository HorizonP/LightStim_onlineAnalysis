%===============Params=====================================================
stim_contrast=0.5;
flipSecs = 1;
spotsR=[50 600]
%% spots_v4
% spotsR=[12.5 25 50 75 100 150 300 450 600 800 1000];
% spotsR=[12.5 25 50 100 150 300 600 800 1000];
% %%
% spotsR=[12.5 25 50 75 100 150 300 600 800 1000];
% spotsR=fliplr(spotsR)
%% spots_v3
% spotsR=[12.5 25 50 100 150 300 600];
%=== spots_v3_reversed
% spotsR=fliplr(spotsR)

%% small&big with a variety of duration
% spotsR=[50 600];
% flipSecs=[1 3 5 7];

%%
% spotsR=[100 600]; % in um, not pixel
% flipSecs = [1 3 5];
% 
% 
% spotsR=[100 600 1000]; % in um, not pixel
% flipSecs = [1];
%% ===============Routine===============
[a,b]=meshgrid(flipSecs,spotsR);
spotsR=b(:)';
flipSecs=a(:)';



for i=1:length(spotsR)         
    kbstate=kbContinue;
    if kbstate==0 %ESC is pressed
        break
    else
        StimSpot(spotsR(i),flipSecs(i),stim_contrast)
    end
end

%save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
% save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));