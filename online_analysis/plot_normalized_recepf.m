function [response,fig]=plot_normalized_recepf(quantify_func,S,x_axis,tit,opts)
% Plot excitatory receptive field of several cells collectively (response
% to spots), by the method in quantify_exc_input
% S is an array of structs, each of which is one recording clip, generated
% by preprocess.m
% see also preprocess quantify_exc_input

normalization_met='ON/OFF separate'; % 'none', 'ON/OFF together'
if exist('opts','var') && ~isempty(opts)
    if isfield(opts,'normalization_met')
        normalization_met=opts.normalization_met;
    end
end

fig=figure;
ax = gca;
hold(ax,'on')
ongrp=hggroup(ax,'DisplayName','ON responses');
offgrp=hggroup(ax,'DisplayName','OFF responses');

response=zeros(numel(S),length(x_axis),2); 
% each row represent one clip, each column represent one size of spot, 
% 1st and 2nd pages represent on and off respectively

for j=1:numel(S)
    dtst=S(j); % one recording clip struct
    [on_response,off_response]=quantify_func(dtst); %
    
    len_max=(min(length(x_axis),size(on_response'))); 
    if len_max~=length(x_axis)
        warning(['response of ' dtst.filename ' has an abnormal length ' num2str(size(on_response'))]);
    end
    
    len=1:len_max; % use the minimum length
    if strcmp(normalization_met,'ON/OFF together') % if gonna normalizing devided by mean(abs(.))
%         disp('ON/OFF together')
        norm=mean([abs(on_response(len)) abs(off_response(len))]);
        on_response=on_response(len)/norm;
        off_response=off_response(len)/norm;
        
    elseif strcmp(normalization_met,'ON/OFF separate') % if gonna normalizing devided by mean(abs(.))
%         disp('ON/OFF separate')
        on_response=on_response(len)/mean(abs(on_response(len)));
        off_response=off_response(len)/mean(abs(off_response(len)));

    else % method: 'none'
%         disp('none')
        on_response=on_response(len);
        off_response=off_response(len);
    end

    p1=plot(ax,x_axis(len),on_response,'Color','r','DisplayName',[num2str(j) ':' dtst.filename '_ON'],'Parent',ongrp); % ON
    p2=plot(ax,x_axis(len),off_response,'Color','b','DisplayName',[num2str(j) ':' dtst.filename '_OFF'],'Parent',offgrp); % OFF
    
    if numel(S)>1 % if more than one dataset, then make each single trace transparent
        p1.Color(4)=0.3; % alpha(p1,0.3) does not work 
        p2.Color(4)=0.3;
    end
    response(j,len,1)=on_response;
    response(j,len,2)=off_response;
end
if numel(S)>1 %if more than one dataset, plot average trace as well as errorbar
    peak_sem=std(response)/sqrt(numel(S));
    errorbar(ax,x_axis(len),mean(response(:,:,1)),peak_sem(:,:,1),'Color','r','DisplayName','ON','LineWidth',1.5,'Parent',ongrp)
    errorbar(ax,x_axis(len),mean(response(:,:,2)),peak_sem(:,:,2),'Color','b','DisplayName','OFF','LineWidth',1.5,'Parent',offgrp)
end
% legend(ax,'show');
ax.XAxisLocation = 'origin';
title(ax,tit,'Interpreter','none');
end