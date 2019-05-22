
stim_contrast=1;
flipSec = 0.5;
x_width=11.5;
y_width=100;
y_offset=0;

Xoffsets=[-5:5]*x_width;

sendComment(['displaced_bars, contrast=' num2str(stim_contrast)],-1);
x_axis=[];
for pos=Xoffsets
    kbstate=kbContinue;
    if kbstate==0 %ESC is pressed
        break
    else
        x_offset=pos;
        StimRectangle([x_width y_width x_offset y_offset],flipSec,stim_contrast);
        x_axis=[x_axis pos];
    end
    
end

