function res=tickRealtime(doc,TargetTick)
% Get the datetime of a target tick in a selection. the accuracy is
% limitted by LabChart's GetRecordStartDate accuracy (which is 1s)
% TargetTick is the index of selectedData matrix in matlab (1-based)
% SelectionStartOffset SelectionStartRecord GetRecordLength blocks
% GetRecordSecsPerTick GetRecordStartDate


% let selectionStartOffset = 0,   no data point on selectionStartOffset
StartBlockStart=0-doc.SelectionStartOffset; % no data point on this tick, first data point is on StartBlockStart+1
block_ind=doc.SelectionStartRecord;
StartBlockEnd=StartBlockStart+doc.GetRecordLength(block_ind);

% SecondBlockStart=StartBlockEnd % no data of 2nd block is on this tick as well

BoundaryMarker=[StartBlockStart StartBlockEnd];
blocks=doc.SelectionStartRecord : doc.SelectionEndRecord;
if length(blocks)>1
    for i=blocks(2:end)
        tmp = BoundaryMarker(end) + doc.GetRecordLength(i);
        BoundaryMarker = [BoundaryMarker tmp];
    end
end

blk=find(TargetTick<=BoundaryMarker,1)-1; % blocks(blk) is the block # (0-based) the targetTick is in
if isempty(blk)||blk==0
    error('TargetTick is out of the selection')
else    
    secsPerTick=doc.GetRecordSecsPerTick(blocks(blk));
    res=datetime(doc.GetRecordStartDate(blocks(blk)))+seconds((TargetTick- (BoundaryMarker(blk)+1) )*secsPerTick);
end
end