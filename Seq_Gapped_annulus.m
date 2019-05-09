%===============Params=====================================================
% specification of *ringsR*: two-row matrix, first row represent outer radius
% in micron, the second row represent inner radius in micron; each column
% represent an annulus
stim_contrast=1;

%======= Annulus with fixed inner diameter
% ringsOR=[150 200 300 400 500 600 700 800]; %um  
% ringsIR=ones(size(ringsOR))*100; %um
% flipSecs= [3];

%======= Annulus with fixed outer diameter
ringsIR=[0 12.5 25 50 100 150 200 300 400]; %um  
ringsOR=ones(size(ringsIR))*600; %um
flipSecs= [3];

%======= Annulus with fixed thickness
% ringsOR=[100 150 200 250 300 350 400 450 500 700 800]; %um
% ringsIR=ringsOR-100; %um
% flipSecs= [1];

% ringsOR=[50 600]; %um
% ringsIR=ones(size(ringsOR))*0; %um
% flipSecs= [3];

% ringsOR=[ 600]; %um
% ringsIR=[400]; %um
% flipSecs= [3];


%===============Routine====================================================
if length(flipSecs)==1
    flipSecs=ones(size(ringsOR))*flipSecs;
end

for i=1:length(flipSecs)
    kbstate=kbContinue;
    if kbstate==0
        break
    else
        StimAnnulus(ringsIR(i),ringsOR(i),flipSecs(i),stim_contrast)
        
        
    end
end

% save workspace to log folder
[~,scriptName,~]=fileparts(mfilename('fullpath'));
% save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));