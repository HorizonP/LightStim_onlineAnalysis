function StimRollingSector(param_screen,Ang,ir,or,totalT,direction)
% display a sector(Ang,ir,or) rotate 'direction'ally 360 degree within 'totalT' time

%=== setup params
struct2vars(param_screen)

%=== units conversion
waitframe = 1; 
startAng=-Ang/2;
rect_L=[0 0 or*2*umTopix or*2*umTopix];
rect_S=[0 0 ir*2*umTopix ir*2*umTopix];
DegreePerSec=360/totalT;
DegreePerFrame=DegreePerSec*ifi;
frames=round(360/DegreePerFrame);

%=== wait key press
WaitSecs(0.15);
[~, keyCode, ~]=KbWait;
if keyCode(41)==1 || keyCode(27)==1 %ESC is pressed
    return
end

%=== main routine
vbl = Screen('Flip', screen_win);
io64(ttlObj,57600,0); ;
for i=1:frames     
    Screen('FillArc',screen_win,screen_w,CenterRectOnPoint(rect_L,xCen,yCen),startAng,Ang);
    Screen('FillOval',screen_win,screen_w*bg_contrast,CenterRectOnPoint(rect_S,xCen,yCen)); % mask inner part
    vbl = Screen('Flip', screen_win, vbl + (waitframe - 0.5) * ifi); %
    io64(ttlObj,57600,1); ;
    startAng=startAng+direction*DegreePerFrame;
end
Screen('Flip', screen_win, vbl + (waitframe - 0.5) * ifi);
io64(ttlObj,57600,0); ;

end