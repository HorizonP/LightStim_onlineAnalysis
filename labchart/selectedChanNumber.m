function chan_bool=selectedChanNumber(doc)
if ~exist('doc','var')
    global gLCDoc
    doc=gLCDoc;
end
N=doc.NumberOfChannels;
chans=0:N-1;
chan_bool=arrayfun(@doc.IsChannelSelected,chans);

end