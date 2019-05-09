function sendComment(comment, channel)
% send comment to current running LabChart recording on certain channel
% only run when the connection to labchart is there
try 
    doc=RunningLCDoc;
    doc.AppendComment(comment,channel);
catch

end

end