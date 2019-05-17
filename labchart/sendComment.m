function sendComment(comment, channel, additional_str)
% send comment to current running LabChart recording on certain channel
% only run when the connection to labchart is there
try 
    doc=RunningLCDoc;
    doc.AppendComment(comment,channel);
catch
end
fid=fopen(fullfile('log',[datestr(now,'yyyymmmdd') '.txt']),'a');
if exist('additional_str','var')
    fprintf(fid,[datestr(now,'HH:MM:SS.FFF') '\t' num2str(channel) '\t' comment '\t' strjoin(additional_str,'\t') '\n']);
else
    fprintf(fid,[datestr(now,'HH:MM:SS.FFF') '\t' num2str(channel) '\t' comment '\n']);
end
fclose(fid);

end