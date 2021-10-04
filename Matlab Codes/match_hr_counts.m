
%Requires frames, smooth_hr, diffs
duration = frames/30;

%Change the line below to read in the right table
t_table = readtable("MPDataExport_2.csv");
ground_truth = table2array(t_table(:,3));
ground_truth_times = table2array(t_table(:,2));
ground_truth_times = ground_truth_times - ground_truth_times(1); %start at t=0
ground_truth_times = ground_truth_times/ground_truth_times(2); %divide out 8192 from all points
ground_truth_times = (ground_truth_times) * duration/ground_truth_times(size(ground_truth_times,1)); %adjust assuming first point is at t=0 sec and last point is at t=duration sec

curr_time = indices(1)/30;
smooth_hr_times = [];
for i=1:size(diffs,2)
    smooth_hr_times = [smooth_hr_times, ((diffs(i)/30)/2)+curr_time]; 
    curr_time = curr_time + diffs(i)/30;
end

smooth_hr_times = transpose(smooth_hr_times);
aligned_hr = [];
count_measured = 1;
count_ground = 1;

%Make all hr with times < first hr measurement = first hr measurement
while(smooth_hr_times(count_measured) >= ground_truth_times(count_ground) && count_ground < size(ground_truth_times,1))
    aligned_hr = [aligned_hr, smooth_hr(count_measured)];
    count_ground = count_ground + 1;
end

count_measured = count_measured + 1;

while(count_ground <= size(ground_truth_times,1) && count_measured < size(smooth_hr_times,1))
    while((count_measured < size(smooth_hr_times,1)) && (smooth_hr_times(count_measured) <= ground_truth_times(count_ground)))
        count_measured = count_measured + 1;
    end
    while((count_ground <= size(ground_truth_times,1)) && (smooth_hr_times(count_measured) > ground_truth_times(count_ground)))
        gap = smooth_hr_times(count_measured) - smooth_hr_times(count_measured - 1);
        ratio_left = 1 - ((ground_truth_times(count_ground) - smooth_hr_times(count_measured - 1))/gap);
        ratio_right = 1 - ((smooth_hr_times(count_measured) - ground_truth_times(count_ground))/gap);
        new_hr =  ratio_left*smooth_hr(count_measured - 1) + ratio_right*smooth_hr(count_measured);
        aligned_hr = [aligned_hr, new_hr];
        count_ground = count_ground + 1;
    end
end

%Make all hr with times > last hr measurement = last hr measurement
%At this point count_measured = size(count_measured,1) or 
%count_ground = size(ground_truth,1)
while(count_ground <= size(ground_truth,1))
    aligned_hr = [aligned_hr, smooth_hr(count_measured)];
    count_ground = count_ground + 1;
end

aligned_hr = transpose(aligned_hr);
plot(ground_truth_times, aligned_hr);
xlabel("Time (in seconds)");
ylabel("Heart Rate (in BPM)");
hold on;
plot(ground_truth_times, ground_truth);
legend({'Heart Rate from 2SR','Ground Truth Heart Rate'},'Location','southwest')
figure;

slice=3;
new_aligned = aligned_hr(slice+1:size(aligned_hr,1)-slice);
new_ground = ground_truth(slice+1:size(ground_truth,1)-slice);
new_time = ground_truth_times(slice+1:size(ground_truth_times,1)-slice);
plot(new_time, new_aligned);
xlabel("Time (in seconds)");
ylabel("Heart Rate (in BPM)");
hold on;
plot(new_time, new_ground);
legend({'Heart Rate from 2SR','Ground Truth Heart Rate'},'Location','southwest')


avg_error_data_points = mean(abs(new_aligned - new_ground))
avg_error_avg_hr = abs(mean(new_aligned) - mean(new_ground))