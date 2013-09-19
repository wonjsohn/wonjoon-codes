
clc;clear;close all
data = dlmread('doornik_curve.txt');
t = data(:,1);
angle = data(:,2);

%% low pass filter 
Fe=150; %Samling frequency
Fc_lpf=5.0; % Cut-off frequency
N=1; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters

lpf_angle=filtfilt(B, A, angle); %in the case of Off-line treatment

%% average multiple mapped values (time to angle) 
angleSum=0;
newT=[];
newAngle=[];
count = 0; % default count

for i=2:length(t)
    if t(i-1) > t(i)  % case that case non-distinct values - remove
        % do nothing and skip
        t(i) = t(i-1);
    else
        angleSum = angleSum +  angle(i);
        count = count + 1;
        if t(i-1) ~= t(i)   % not equal to
             averageAngle=angleSum/count;
             count=0;
             angleSum = 0;
             newT = [newT t(i)];
             newAngle = [newAngle averageAngle];
        end
    end
end
newT = transpose(newT);
newAngle = transpose(newAngle);

%% make distinct values (eliminate duplicates)
% unique_newT = unique(newT);


% plot(newT, newAngle, '.');

%% interpolate dots.. regularize intervals.

xx = 1:.03:80;
yy = interp1(newT, newAngle, xx);
plot(xx, yy);

dlmwrite('doornik_curve_resampled.txt', [transpose(xx) transpose(yy)], 'delimiter', ',');

% define a grid for latitude (x) and longitude(y)




% plot(newT, newAngle, ' o',  x, y, '-');

% figure;
% plot(t, angle);
% figure;
% plot(t, lpf_angle);