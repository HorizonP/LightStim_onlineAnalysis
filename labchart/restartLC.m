function restartLC()
% re-establish global variable of gLCApp and gLCDoc (as running LC doc)

ClearLC; % will do ReleaseLC & ReleaseLCDoc and clear global variables
GetLCApp; % create global variable gLCApp
global gLCDoc
gLCDoc=RunningLCDoc;
end
