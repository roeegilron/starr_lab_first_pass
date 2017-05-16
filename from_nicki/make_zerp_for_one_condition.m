function ...
    [erp,...
    zerp,...
    mean_of_prestimulus_segment_of_erp,...
    surrogate_erp_fit]=...
    make_zerp_for_one_condition(...
    signal,...
    event_indices,...
    start_epoch_at_this_sample_point,...
    stop_epoch_at_this_sample_point,...
    start_baseline_at_this_sample_point,...
    stop_baseline_at_this_sample_point,...
    skip)

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

%makes erps and also zerps (harder to interpret)

number_of_sample_points_in_signal=size(signal,2);
number_of_surrogate_runs=size(skip,2);
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
zerp=zeros(size(erp),'single');
surrogate_erp=zeros(1,number_of_surrogate_runs,'single');
surrogate_erp_fit=zeros(2,1,'single');
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

for s=1:number_of_surrogate_runs  %
    surrogate_event_indices=...
        mod(event_indices+skip(s),...
        number_of_sample_points_in_signal);
    surrogate_event_indices(...    %gives random indices that never exceed number of sample points in signal 
        find(...     
        surrogate_event_indices==0))=...
        number_of_sample_points_in_signal;%if random value happened to correspond to the end of the dataset, mod = 0, but set to end of dataset.
    surrogate_erp(s)=mean(signal(surrogate_event_indices));
end
[surrogate_erp_fit(1),surrogate_erp_fit(2)]=...
    normfit(double(surrogate_erp));
zerp=(erp-repmat(...              %z correct erps by comparing to surrogate runs
    surrogate_erp_fit(1),size(erp)))./...    %subtracts erp from something like mean divided by sd of normal suurogate data
    repmat(surrogate_erp_fit(2),size(erp));
erp=erp-...
    repmat(...     %removes baseline 
    mean_of_prestimulus_segment_of_erp,...
    1,size(erp,2));
