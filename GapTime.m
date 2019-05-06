function exit=GapTime(gapTime)
% an interruptable GapTime function, less accurate in terms of timing
exit=false;
stmp=GetSecs();
while GetSecs()-stmp < gapTime
    [keyIsDown, ~, keyCode, ~]=KbCheck;
    if keyIsDown==1 && (keyCode(41)==1 || keyCode(27)==1) 
        exit=true;
        break
    end
end
end