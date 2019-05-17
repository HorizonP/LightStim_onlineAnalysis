function res=selectionInfo(doc)
% return a struct of information of current selection of doc, all 1-based
res=struct();
res.startOffset=doc.SelectionStartOffset;
res.startBlock=doc.SelectionStartRecord+1;
res.endOffset=doc.SelectionEndOffset;
res.endBlock=doc.SelectionEndRecord+1;

res.chan_bool=selectedChanNumber(doc);
tmp=1:length(res.chan_bool); 
res.selectedChans=tmp(res.chan_bool); 
end