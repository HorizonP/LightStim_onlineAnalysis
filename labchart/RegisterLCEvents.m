function RegisterLCEvents()
%Hooks up the callback functions in LCCallBacks.m to the events generated
%by the LabChart document. These callbacks use global variables to share
%state.
global gLCDoc;
global gChans;

%Disconnect any existing event handlers
if not(isempty(gLCDoc)) & gLCDoc.isinterface & not(isempty(gLCDoc.eventlisteners))
    gLCDoc.unregisterallevents;
end

% gLCDoc = doc;
gChans = [1,4];
gLCDoc.registerevent({
    'OnStartSamplingBlock' LCCallBacks('OnBlockStart'); 
    'OnFinishSamplingBlock' LCCallBacks('OnBlockFinish')
    'OnSelectionChange' LCCallBacks('OnSelectionChange')
    })

%     'OnNewSamples' LCCallBacks('OnNewSamples');

