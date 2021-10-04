indices = ampd(p_blocked);
%load('ground_truth')
%ground_truth = table2array("MPDataExport_2.csv");
t_table = readtable("MPDataExport_2.csv");
ground_truth = table2array(t_table(:,3));
ground_truth_times = table2array(t_table(:,2));
%%%%Detect peaks with findpeaks function and estimate HR
% [pks,locs] = findpeaks(p_blocked, 'MinPeakHeight',0.001);
% heart_rates = zeros(1,size(locs,1)-1);
% for i = 1:size(locs,1)-1
%     diff = locs(i+1)-locs(i);
%     heart_rates(i) = (1/(diff*(1/30)))*60;
% end

%%%%%%%%%% Estimate HR with threshold applied AMPD
% indices_tmp = [];
% for i = 1:size(indices,2)
%     if p_blocked(indices(i)) >= 0.001
%         indices_tmp = [indices_tmp indices(i)];
%     end
% end
% heart_rates = zeros(1,size(indices_tmp,2)-1);
% for i = 1:size(indices_tmp,2)-1
%     diff = indices_tmp(i+1)-indices_tmp(i);
%     heart_rates(i) = (1/(diff*(1/30)))*60;
% end
% avg_hr = sum(heart_rates)/size(heart_rates,2);

%%%%%%Estimate HR with AMPD
% heart_rates = zeros(1,size(indices,2)-1);
% for i = 1:size(indices,2)-1
%     diff = indices(i+1)-indices(i);
%     heart_rates(i) = (1/(diff*(1/30)))*60;
% end
% avg_hr = sum(heart_rates)/size(heart_rates,2);

%Find the number of false peaks
num_falsepeaks = 1;
count = 1;
while(size(indices,2)>= count+1)
    diff = indices(count+1)-indices(count);
    val = (1/(diff*(1/30)))*60;
    if val >= 120 && (count+2 <= size(indices,2))
       num_falsepeaks = num_falsepeaks+1;
       count = count+1;
    end
    count = count+1;
end

%Calculate the heart rate
heart_rates = zeros(1,size(indices,2)-1-num_falsepeaks);
count = 1;
index = 1;
used = 1;
diffs = [];
while(size(indices,2)>= count+1)
    diff = indices(count+1)-indices(count);
    heart_rates(index) = (1/(diff*(1/30)))*60; 
    if heart_rates(index) >= 121 && (count+2 <= size(indices,2))
        used = used+1;
        diff = indices(count+2)-indices(count);
        heart_rates(index)  = (1/(diff*(1/30)))*60;
        count = count+1;
    end
    diffs = [diffs diff];
    index = index+1;
   count = count+1;
end

smooth_hr = smooth(smooth(heart_rates));
%figure()
%plot(ground_truth)
%hold on
%plot(smooth_hr)
% %avg_hr = sum(heart_rates)/size(heart_rates,2); %Average heart rate
% avg_hr = sum(smooth_hr)/size(smooth_hr,1);
