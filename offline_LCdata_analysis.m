x_axis=fliplr(spotsR);

tst=LCAnalysis;
opts=[];
[on,off]=quantify_mean(tst,opts)



figure;
plot(x_axis,off,x_axis,on,'Marker','*')



