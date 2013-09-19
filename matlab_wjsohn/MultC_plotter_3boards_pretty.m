    clc; clear;close all;

% load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_test_20130815_063450.mat');
% load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_CN_general_20130815_063452.mat');
% load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_emg_20130815_063455.mat');
cd /home/eric/nerf_verilog_eric/source/py/multC_tester

fname1 = sprintf('rack_test_20130820_160847');
fname2 = sprintf('rack_CN_simple_general_20130820_160848');
fname3 = sprintf('rack_emg_20130820_160849');

load([fname1, '.mat']);
load([fname2, '.mat']);
load([fname3, '.mat']);


%% three boards
[r, c]=size(mixed_input)
t = 1:1:r;

% mixed_input
% Ia_spindle0
% f_emg
% total_force
% raster0_31_MN1
% fixed_drive_to_CN

% legend('length', 'Ia__spindle', 'spkcnt__Ia', 'spkcnt__II', 'emg__MN', 'RECT__EMG', 'spkcnt__CN', 'spkcnt__total__MNs', 'total__force');
% title( ['threeboards__normal, stretch_from 0.8 to 1.4, syn_SN_Ia_gain: 2.0, syn_SN_II_gain: 1.5, syn_CN_gain:50 ', num2str(date),  datestr(now, '  HH:MM:SS')]);
%
%% process EMG
% t_bic= data_bic(:,1);
% t_tri= data_tri(:,1);
% length_bic = data_bic(:,2);
% length_tri = data_tri(:,2);
% vel_bic = data_bic(:,3);
% vel_tri = data_tri(:,3);
% f_emg_bic = data_bic(:,6);
% f_emg_tri = data_tri(:,6);
% force_bic = data_bic(:,5);
% force_tri = data_tri(:,5);

n = 5;
start =50;
%start = 1250;
last = min(length(t), 40000); 
% last = min(length(t_bic), 1000); %2050
subplot(n, 1, 1);


[pks,high_locs] = findpeaks(mixed_input)
mixed_input_inverted = -mixed_input;
[~,low_locs] = findpeaks(mixed_input_inverted)

%% 


%% EMG processing
Fe=150; %Samling frequency
Fc_lpf=20.0; % Cut-off frequency
Fc_hpf=1;
N=2; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters
% 
% % high pass -> rectify -> low pass
% EMG_high_bic=filtfilt(D, C, f_emg); %in the case of Off-line treatment
% f_rec_emg_bic = abs(EMG_high_bic);  % rectify
% EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment
% 
% % EMG_high_tri=filtfilt(D, C, f_emg_tri); %in the case of Off-line treatment
% % f_rec_emg_tri = abs(EMG_high_tri);  % rectify
% % EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment

%%
figure_width  = 8*2;
figure_height = 6*2;
FontSize = 11*1.5;
FontName = 'MyriadPro-Regular';

hfig  = figure(1); 

    set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 


% axis off;  
hLine1 = line(t(start:last), mixed_input(start:last));
% hdots_high = line(t_bic(high_locs),length_bic(high_locs));
% hdots_low = line(t_bic(low_locs),length_bic(low_locs));
 
set(hLine1                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
set(gca,'YLim',[0.5 1.6])
hYLabel = ylabel('flexor length');

% hTitle  = title ('extra cortical drive scale: 7 ');
% hTitle  = title ('flexor muscle length. High Trascortical reflex gain: 3 ');

subplot (n,1, 2);
hLine2 = line(t(start:last), Ia_spindle0(start:last));
set(hLine2                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
axis off;
hYLabel = ylabel('Ia afferent');



subplot (n,1, 3);
hLine3 = line(t(start:last), II_spindle0(start:last));
set(hLine3                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
% set(gca,'YLim',[0 200])
axis off;

% hXLabel = xlabel('time (s)');
hYLabel = ylabel('II afferent');



subplot (n,1, 4);
hLine3 = line(t(start:last), f_emg(start:last));
set(hLine3                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 2.0           , ...   
  'Color'           , 'black'  );
% set(gca,'YLim',[0 200])
axis off;

% hXLabel = xlabel('time (s)');
hYLabel = ylabel('emg');

% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_bic)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_bic(start:last), extraCN(start:last));
% hYLabel  = ylabel('extra drive');
% 
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [.1 .4 .4]  );
% set(gca,'YLim',[0 10])

% %% velocity
subplot (n,1, 5);
hLine4 = line(t(start:last), total_force(start:last));
set(hLine4                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
% set(gca,'YLim',[0 200])
axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('force');



            

% hLine5 = line(t(start:last), raster0_31_MN1(start:last));


    
% 
% set(hLine5                        , ...
%   'LineStyle'       , '.'         , ...
%   'LineWidth'       , 0.2           , ...   
%   'Color'           , 'black'  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('raster MN1');

%%
% hfig2  = figure(2); 
% last = min(length(t_tri), 22000) 
% set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
%     % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
%     set(gcf, 'PaperPositionMode', 'auto');
%     set(gcf, 'Color', [1 1 1]); % Sets figure background
%     set(gca, 'Color', [1 1 1]); % Sets axes background
%     set(gcf, 'Renderer', 'painters'); 
% 
% subplot(n, 1, 1);
% hLine4 = line(t_tri(start:last), length_tri(start:last));
% set(hLine4                        , ...
%   'LineStyle'       , '-'        , ...
%   'LineWidth'       , 2           , ... 
%   'Color'           , [0.75 0 0]  );
% % set(gca,'YLim',[0.55 1.1])
% set(gca,'YLim',[0.65 1.2])
% hYLabel = ylabel('Extensor length');
% 
% subplot (n,1, 2);
% hLine5 = line(t_tri(start:last), f_emg_tri(start:last));
% set(hLine5                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 0.2           , ...   
%   'Color'           , [0 0 0.75]  );
% axis off;
% 
% subplot (n,1, 3);
% hLine6 = line(t_tri(start:last), force_tri(start:last));
% set(hLine6                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('Extensor force');
% 
% 
% % subplot (n,1, 4);
% % 
% % extraCN = transpose(ones(1, length(t_tri)));
% % extraCN(1600:last) = 7;
% % hLine4 = line(t_tri(start:last), extraCN(start:last));
% % hYLabel  = ylabel('extra drive');
% % 
% % set(hLine4                        , ...
% %   'LineStyle'       , '-'         , ...
% %   'LineWidth'       , 2           , ...   
% %   'Color'           , [.1 .4 .4]  );
% % set(gca,'YLim',[0 10])
% % 
% % 
% 
% 
% 
% 
% %% vel 
% subplot (n,1, 4);
% hLine9 = line(t_tri(start:last), vel_tri(start:last));
% set(hLine9                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('vel');


% % 
% hLegend = legend( ...
%   [hdots, hLine1, hLine2, hLine3], ...
%   'Data' , ...
%   'Model'    , ...  
%   'Fit'      , ...
%   'Validation Data'       , ...  
%   'location', 'Best' );
 
  %'Data (\mu \pm \sigma)' , ...
  %'Model (\it{C x^3})'    , ...  
  %'Fit (\it{C x^3})'      , ...
  

%% save figure
%print(hfig, '-dpng', (['figure' num2str(date),  datestr(now, '  HH:MM:SS')]);
% 
% fname = sprintf('myfile%d.mat', i);
print(hfig, '-dpng', [fname1, '_openloop']);
% print(hfig2, '-dpng', [fname, '_perturb_tri']);

%-dpng 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % n=6;
% % 
% % subplot(n, 1, 1);
% % t= data_bic(:,1);
% % plot(t, data_bic(:,2), 'LineWidth',2);
% % ylim([0.7 1.3])
% % legend('biceps length');
% % % grid on
% % 
% % subplot(n, 1, 2);
% % plot( t, f_emg_bic);
% % legend('full wave rect biceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % 
% % subplot(n, 1, 3);
% % plot(t, force_bic, 'r', 'LineWidth',2);
% % legend('force bicpes');
% % % grid on
% % 
% % 
% % subplot(n, 1, 4);
% % t= data_tri(:,1);
% % plot(t, data_tri(:,2),'LineWidth',2);
% % legend('triceps length');
% % ylim([0.7 1.3])
% % % grid on
% % 
% % subplot(n, 1, 5);
% % plot(t, f_emg_tri);
% % legend('full wave rect triceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % % ylim([0 40])
% % 
% % 
% % subplot(n, 1, 6);
% % plot(t, force_tri, 'r', 'LineWidth',2);
% % legend('force triceps');
% % % grid on


% % % ylim([-2000 4000])
% % % subplot(3, 1, 3);
% % % endtime = 2600; 
% % % plot(t(1:endtime),  data_bic(1:endtime,5)-data_tri(1:endtime,5));
% % % legend('diff in force');
% % % grid on
% % title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1: 0, CNsynGain=50.0, extraCN2: 15000*sin(t)   ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% % %title( ['pymunk setting, IaGain=1.5, IIGain=1.5, extraCN1:120000, extraCN2: 80000*sin(t) ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% % %title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1:50000, extraCN2: 40000*sin(t)', num2str(date),  datestr(now, '  HH:MM:SS')]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% filter exploration
% ** Ap — amount of ripple allowed in the pass band in decibels (the default units). Also called Apass.
% ** Ast — attenuation in the stop band in decibels (the default units). Also called Astop.
% ** F3db — cutoff frequency for the point 3 dB point below the passband value. Specified in normalized frequency units.
% ** Fc — cutoff frequency for the point 6 dB point below the passband value. Specified in normalized frequency units.
% ** Fp — frequency at the start of the pass band. Specified in normalized frequency units. Also called Fpass.
% ** Fst — frequency at the end of the stop band. Specified in normalized frequency units. Also called Fstop.
% ** N — filter order.
% 
% 
% plot(t(1:100), f_emg_bic(1:100));
% figure
% 
% d=fdesign.highpass('N,Fc',5, 1,400);
% %designmethods(d)
% Hd = design(d);
% % fvtool(Hd);
% % d=design(h,'equiripple'); %Lowpass FIR filter
% %y=filtfilt(Hd,f_emg_bic ); %zero-phase filtering
% y1=filter(Hd,f_emg_bic); %conventional filtering
% 
% 
% plot(t(1:100), y1(1:100));
% title('Filtered Waveforms');
% figure;
% rect_y1 = abs(y1);
% plot(t(1:100), rect_y1(1:100));
% figure;
%  
% %d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.15,0.25,1,60);
% d=fdesign.lowpass('N,Fc',3, 3, 400);
% designmethods(d)
% Hd = design(d);
% y2=filter(Hd, rect_y1); %conventional filtering
% plot(t(1:100), y2(1:100));
% fvtool(Hd);
% 

% y=filtfilt(d.Numerator,1, f_emg_bic); %zero-phase filtering
% y1=filter(d.Numerator,1, f_emg_bic); %conventional filtering


