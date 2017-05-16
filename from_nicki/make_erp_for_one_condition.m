function ...
    [erp,...
    mean_of_prestimulus_segment_of_erp]=...
    make_erp_for_one_condition_no_baseline(...
    signal,...
    event_indices,...
    start_epoch_at_this_sample_point,...
    stop_epoch_at_this_sample_point,...
    start_baseline_at_this_sample_point,...
    stop_baseline_at_this_sample_point)

% function
%     [erp,...
%     zerp,...
%     mean_of_prestimulus_segment_of_erp,...
%     surrogate_erp_fit]=...
%     make_zerp_for_one_condition(...
%     signal,...
%     event_indices,...
%     start_epoch_at_this_sample_point,...
%     stop_epoch_at_this_sample_point,...
%     start_baseline_at_this_sample_point,...
%     stop_baseline_at_this_sample_point,...
%     skip)

%makes erps only

number_of_sample_points_in_signal=size(signal,2);
event_indices(find(event_indices<...   %deletes event indices before epoch start time, so any event indices 
    abs(start_epoch_at_this_sample_point)))=[];     %that don't have enough prestimulus interval
event_indices(find(event_indices>...
    number_of_sample_points_in_signal-...        %likes wise exclude epochs w/o enough post event time points
    abs(stop_epoch_at_this_sample_point)))=[];
number_of_epochs=length(event_indices);
number_of_sample_points_in_epoch=...
    length(...
    start_epoch_at_this_sample_point:...
    stop_epoch_at_this_sample_point);

erp=zeros(number_of_sample_points_in_epoch,1,'single');
normalizer=1/number_of_epochs;

for e=1:number_of_epochs   %pulls out signal epochs
    segment=signal(...
        event_indices(e)+...
        (start_epoch_at_this_sample_point:...
        stop_epoch_at_this_sample_point))';
    erp=erp+segment;  %makes a sum of values
end
erp=erp*normalizer;  %divides by number of epochs
mean_of_prestimulus_segment_of_erp=...    %pulls out part before epoch, and means the erp of the baseline to get a single value
    mean(erp(abs(start_epoch_at_this_sample_point)+...
    (start_baseline_at_this_sample_point+1:...
    stop_baseline_at_this_sample_point)));

erp=erp-...
    repmat(...     %baseline removal
    mean_of_prestimulus_segment_of_erp,...
    1,size(erp,2));
