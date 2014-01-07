%% Latency Analysis 
% Eric W. Sohn  
% wonjoons@usc.edu
%

%% working directory
cd /home/eric/wonjoon_codes/matlab_wjsohn/latencyAnalysis

d = dir('*.mat');
[x,y]=sort(datenum(char({d.date})));
most_recent_file=char(d(y(end-2)).name);   %rack_emg_2013xxx
second_recent_file=char(d(y(end)).name);  %rack_test_2013xxx

load(most_recent_file);
% fname1 = sprintf('gain1_rack_emg_20131011_135736_rack_test_20131011_135734'); 
% load([fname1, '.mat']);

t1 = t_cut;
len1 =mixed_input_cut;
emg1 =f_emg_cut;
spkcnt1 = total_spike_count_sync_cut;

% fname2 = sprintf('gain8_rack_emg_20131011_140239_rack_test_20131011_140238'); 
% load([fname2, '.mat']);
load(second_recent_file);
t2 = t_cut;
len2 =mixed_input_cut;
emg2 =f_emg_cut;
spkcnt2 = total_spike_count_sync_cut;
% fname3 = sprintf('gain8_rack_emg_20131009_172540_rack_test_20131009_172538'); 
% load([fname3, '.mat']);
% t3 = t_cut;
% len3 =mixed_input_cut;
% emg3 =f_emg_cut;
% fname4 = sprintf('gain8_rack_emg_20131009_174457_rack_test_20131009_174455'); 
% load([fname4, '.mat']);
% t4 = t_cut;
% len4 =mixed_input_cut;
% emg4 =f_emg_cut;


%% EMG processing
% Fe=33; %Samling frequency
Fe = 1030;
Fc_lpf=350.0; % Cut-off frequency
Fc_hpf=3.0;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high=filtfilt(D, C, emg1); %in the case of Off-line treatment
rec_emg = abs(EMG_high);  % rectify
EMG_1=filtfilt(B, A, rec_emg); %in the case of Off-line treatment

EMG_high2=filtfilt(D, C, emg2); %in the case of Off-line treatment
rec_emg2 = abs(EMG_high2);  % rectify
EMG_2=filtfilt(B, A, rec_emg2); %in the case of Off-line treatment
% 



hold on
n=3;
subplot(n, 1, 1);

plot(t1, len1, 'LineWidth',2, 'color', 'red');  
hold on
plot(t1, len2, 'LineWidth',2, 'color', 'black'); 
hold on

% plot(t1, len3, 'LineWidth',2, 'color', 'black'); 
% hold on
% plot(t1, len4, 'LineWidth',2, 'color', 'black'); 
%     [pks, locs] = findpeaks(length_bic_cut);
axis off

subplot(n, 1, 2); 
plot(t1, EMG_1, 'LineWidth',2, 'color', 'red');
hold on
plot(t1, EMG_2, 'LineWidth',2, 'color', 'black');

hold on
% plot(t1, emg3, 'LineWidth',2, 'color', 'black');
% hold on
% plot(t1, emg4, 'LineWidth',2, 'color', 'black');
% axis off
% hold on

subplot(n, 1, 3); 
plot(t1, spkcnt1, 'LineWidth',2, 'color', 'red');
hold on
plot(t1, spkcnt2, 'LineWidth',2, 'color', 'black');

hold on
title('perturbation response, 100ms rising time'); 







%%  

  