function sendComment(comment, channel)
% send comment to current running LabChart recording on certain channel

try 
    doc=RunningLCDoc;
catch % if somehow the link to LabChart is broken
    % try to re-establish LabChart connection
    ClearLC; % ReleaseLC and clear the global variable gLCApp and gLCDoc
    GetLCApp;
    doc=RunningLCDoc;
end

doc.AppendComment(comment,channel);

end