function sli=slicing_with_derivative(obj,prev_on,after_off)
    % prev_on: how long should be selected before beginning of
    % stimulus. after_off: how long should be selected after the
    % end of stimulus. Duration in second.
    time_on_Tn=round(mean(obj.descendT-obj.ascendT)); %Tn
    selection=obj.ascendT'+(-prev_on*obj.tickrate:time_on_Tn + after_off*obj.tickrate);
    data=obj.chan2;
    
    %=== exception handling: selection out of boundary
    if min(min(selection))<1
        left_vacancy=abs(min(min(selection)))+1; % number of NaN to added to the left of data to prevent "selection out of boundary problem"
        data=[ones(1,left_vacancy)*NaN data];
        selection=selection+left_vacancy;
    end
    if max(max(selection))>length(data)
        right_vacancy=max(max(selection))-length(data); % number of NaN to added to the right of data to prevent "selection out of boundary problem"
        data=[data ones(1,right_vacancy)*NaN];
    end
    %===
    
    chan2_sel=data(selection);
    deriv_sel=obj.derivative(selection);
    t_axis=(selection(1,:)-selection(1,prev_on*obj.tickrate))/obj.tickrate; % create a time axis whose zero point at the first point stimulus onset
%     t_axis=obj.T(selection(1,:))-obj.T(selection(1,prev_on*obj.tickrate));
    sli=struct();
%     sli.sel=selection; % indexing array for other indexing purpose
    sli.t_axis=t_axis; % the time axis facilitating plot
    sli.response_arr=chan2_sel; % -mean(chan2_sel(:,1:prev_on*obj.tickrate),2)
    sli.derivative_arr=deriv_sel;
    sli.stim_duration=time_on_Tn/obj.tickrate;
    sli.deriv_thre=3*std(obj.derivative); % the threshold of spike calculated from whole trace of obj
end