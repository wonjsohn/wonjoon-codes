%% Latency Analysis
% Eric W. Sohn  
% wonjoons@usc.edu
% This program detects the rise in length and cut according that point.
% Useful if the input length is flat elsewhere. (not useful in closed loop
% simulation)


clc;clear;close all;
%% set working directory
% cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk
cd /home/eric/nerf_verilog_eric/source/py/multC_tester

d = dir('*.mat');
[x,y]=sort(datenum(char({d.date})));
most_recent_file=char(d(y(end)).name);   %rack_emg_2013xxx
second_recent_file=char(d(y(end-1)).name);  %rack_test_2013xxx

load(most_recent_file);
load(second_recent_file);


%% specify files to read from
% fname2 = sprintf('rack_test_20131011_140238');   % spindle part
% fname2_emg = sprintf('rack_emg_20131011_140239');   %  motor part
% load([fname2, '.mat']); 
% load([fname2_emg, '.mat']);


[r, c]=size(mixed_input)
t = 1:1:r;
 
n = 3;

%% plot 
hfig1 = figure(1);
subplot(n, 1, 1); 
plot(t, mixed_input, 'LineWidth',2, 'color', 'black');    
%     [pks, locs] = findpeaks(length_bic_cut);
axis off

subplot(n, 1, 2); 
plot(t, f_emg, 'LineWidth',2, 'color', 'black');
axis off

subplot(n, 1, 3); 
plot(t, total_spike_count_sync, 'LineWidth',2, 'color', 'black');
axis off


%% find perturbation onset index
[index]=find_perturb_onset(mixed_input);


buffer = 100;
perturbation_length=354;  % try to set the same half-cnt so this value can be consistent
perturbation_onset = index;
start=perturbation_onset - buffer;    
last = start + perturbation_length + 2*buffer;


t_cut= t(start:last);
mixed_input_cut = mixed_input(start:last);
f_emg_cut = f_emg(start:last);
total_spike_count_sync_cut = total_spike_count_sync(start:last);


hfig2 = figure(2);
n=3;
subplot(n, 1, 1);

plot(t_cut, mixed_input_cut, 'LineWidth',2, 'color', 'black');    
%     [pks, locs] = findpeaks(length_bic_cut);

axis off

subplot(n, 1, 2); 
plot(t_cut, f_emg_cut, 'LineWidth',2, 'color', 'black');
axis off

subplot(n, 1, 3); 
plot(t_cut, total_spike_count_sync_cut, 'LineWidth',2, 'color', 'black');
axis off

cd /home/eric/wonjoon_codes/matlab_wjsohn/latencyAnalysis
[pathstr,most_recent_name,ext] = fileparts(most_recent_file) 
[pathstr,second_recent_name,ext] = fileparts(second_recent_file) 

save(['CUT_', most_recent_name, '_', second_recent_name], 't_cut', 'mixed_input_cut', 'f_emg_cut', 'total_spike_count_sync_cut');

%%  



  