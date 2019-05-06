function state=kbContinue(varargin)
% state is 1 (true) suggest the routine should continue, state is 0
% suggests the routine should escape
if isempty(varargin)
    WaitSecs(0.15);
    while true
        [~,keyc]=KbWait();
        if strcmp(KbName(keyc),'esc')
            state=0;
            break
        end
        if strcmp(KbName(keyc),'f12')
            state=1;
            break
        end
    end
end

end
