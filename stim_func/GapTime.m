function exit=GapTime(gapTime)
% an interruptable GapTime function, less accurate in terms of timing
exit=false;
stmp=GetSecs();
while GetSecs()-stmp < gapTime
    [~,keyCode]=KbWait([],0,stmp+gapTime);
%     [keyIsDown, ~, keyCode, ~]=KbCheck;
%     if keyIsDown==1 && strcmp(KbName(keyCode),'esc')
    % when shift key is pressed, the keycode is a cell array
    if any(strcmp(KbName(keyCode),'esc')) %|| isempty(keyCode)
        exit=true;
        break
    end
end
end