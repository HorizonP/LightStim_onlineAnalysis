function StimUntimedCheckboard(param_screen,mosaicSzInReal,stim_contrast)

struct2vars(param_screen)
r=150;%pix
ActualRect=[xCen-r,yCen-r,xCen+r,yCen+r];
intensity=screen_w*stim_contrast;

magnify=mosaicSzInReal*umTopix;
mosaicNum=round([(ActualRect(4)-ActualRect(2))/magnify (ActualRect(3)-ActualRect(1))/magnify]);

im=randi([0,1],mosaicNum)*intensity;
aTexInd=Screen('MakeTexture',screen_win,im);
Screen('DrawTexture',screen_win,aTexInd,[],ActualRect,[],0);
Screen('Flip', screen_win);
io64(ttlObj,57600,0);


kbContinue;
vbl = Screen('Flip', screen_win);
io64(ttlObj,57600,1);

end