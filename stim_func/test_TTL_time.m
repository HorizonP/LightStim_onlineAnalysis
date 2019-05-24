ttlObj=io64;
stat=io64(ttlObj);
io64(ttlObj,57600,0);
WaitSecs(0);

% topPriorityLevel = MaxPriority(screen_win);
% Priority(topPriorityLevel);

Ntrial=100;
tsp=zeros(1,Ntrial*2+1);
tsp2=zeros(1,Ntrial*2);
wa=0.05;
tsp(1)=GetSecs;
for i=1:Ntrial
    tsp(i*2)=WaitSecs('UntilTime',tsp(i*2-1)+wa);
    io64(ttlObj,57600,1); 
    tsp2(i*2-1)=GetSecs;
    tsp(i*2+1)=WaitSecs('UntilTime',tsp(i*2)+wa);
    io64(ttlObj,57600,0); 
    tsp2(i*2)=GetSecs;
end

mean(tsp2-tsp(2:end))
var(tsp2-tsp(2:end))
%%
getTS(Ntrial)
function retrivedTS=getTS(Ntrial)
    doc=RunningLCDoc();
    col=1; % the column number in labchart datapad
%     assert(strcmp('Extract Numbers in Comment Text',doc.GetDataPadColumnFuncName(col)));
    getVal=@(row) doc.GetDataPadValue(1,row,col);

    row_offset=4; % first data in datapad is in row #5
    retrivedTS=arrayfun(getVal,[1:Ntrial]+row_offset,'UniformOutput',false); 
end