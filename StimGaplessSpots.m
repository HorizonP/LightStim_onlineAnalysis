function StimGaplessSpots(param_screen,spotsR,flipSecs,options)

struct2vars(param_screen)
if length(flipSecs)==1
    flipSecs=flipSecs*ones(size(spotsR));
end
spotsDiaPix=spotsR*2*umTopix;
waitframes = [0 round(flipSecs / ifi)]; % append 0 at first is to flip the first stim without waiting

%=== wait for key
if exist('options','var') && ~isempty(options) && options(1)==1
    WaitSecs(0.2)
    [~, keyCode, ~]=KbWait;
    if keyCode(41)==1 || keyCode(27)==1 %ESC is pressed
        return
    end
end
%===

vbl = Screen('Flip', screen_win);
for i=1:length(spotsR)
    spotsDia=spotsDiaPix(i);
    Screen('FillOval', screen_win, screen_w ,[xCen-0.5*spotsDia yCen-0.5*spotsDia xCen+0.5*spotsDia yCen+0.5*spotsDia]);
    lptwrite(57600, 0);
    vbl = Screen('Flip', screen_win, vbl + (waitframes(i) - 0.5) * ifi); %
    lptwrite(57600, 1);
    Radius_Secs=[spotsR(i),flipSecs(i)]
end
Screen('Flip', screen_win, vbl + (waitframes(i+1) - 0.5) * ifi)
lptwrite(57600, 0);
% time=vbl-vbl


% %save workspace to log folder
% [~,scriptName,~]=fileparts(mfilename('fullpath'));
% % save(fullfile('log',[scriptName datestr(datetime,'yyyymmddHHMMSS') '.mat']));
end