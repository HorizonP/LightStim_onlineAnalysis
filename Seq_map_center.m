% map the center position by screening a bar along x-axis and y-axis
% respectively

leng=100; %um 
width=25; %um
stim_contrast=1;
pos_seq=[-5:5]; % 0 refer to bar centered on center, +1 refer to bar centered on +1*width

flipSecs=0.5; %s
gapT=0.5; %s
%% ===============Routine===============
comment=['current center coordinate: (' num2str(param_screen.xCen) ',' num2str(param_screen.yCen) ')'];
sendComment(comment, 4)
% map over x-axis of screen

for pos=pos_seq
    xWidth_yWidth_posX_posY=[width leng pos*width 0];
    StimRectangle(xWidth_yWidth_posX_posY,flipSecs,stim_contrast)
    exit=GapTime(gapT);
        if exit
            break
        end
%         x_axis=[x_axis ];
end

exit=GapTime(gapT);
if exit
    return
end

% map over y-axis of screen
for pos=pos_seq
    xWidth_yWidth_posX_posY=[leng width 0 pos*width];
    StimRectangle(xWidth_yWidth_posX_posY,flipSecs,stim_contrast)
    exit=GapTime(gapT);
        if exit
            break
        end
%         x_axis=[x_axis ];
end