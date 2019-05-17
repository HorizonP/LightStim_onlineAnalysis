function setSelection(doc,selc)
doc.SelectChannel(-1,false); % de-select all channels
doc.SetSelectionRange(selc.startBlock-1,selc.startOffset,selc.endBlock-1,selc.endOffset);
for i=selc.selectedChans
    doc.SelectChannel(i-1,true); 
end
end