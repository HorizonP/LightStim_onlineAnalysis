function StimGaplessSpots(spotsR,flipSecs,options)
global param_screen
struct2vars(param_screen)
if length(flipSecs)==1
    flipSecs=flipSecs*ones(size(spotsR));
end
spotsDiaPix=spotsR*2*umTopix;
waitframes = [0 round(flipSecs / ifi)]; % append 0 at first is to flip the first stim without waiting

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    kbstate=kbContinue;
    if kbstate==0
        return
    end
end
%===

vbl = Screen('Flip', screen_win);
for i=1:length(spotsR)
    spotsDia=spotsDiaPix(i);
    Screen('FillOval', screen_win, screen_w ,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
    io64(ttlObj,57600,0);
    vbl = Screen('Flip', screen_win, vbl + (waitframes(i) - 0.5) * ifi); %
    io64(ttlObj,57600,1);
    Radius_Secs=[spotsR(i),flipSecs(i)]
    sendComment(['(auto) Spot: r=' num2str(spotsR(i)) 'um, contrast=' num2str(1)],4)
end
Screen('Flip', screen_win, vbl + (waitframes(i+1) - 0.5) * ifi)
io64(ttlObj,57600,0);
% time=vbl-vbl


% %save workspace to log folder
% [~,scriptName,~]=fileparts(mfilename('fullpath'));
% % save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));
end