    % clc; clear;%close all;
%   load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174406.mat');  %
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174627.mat');%
%  load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174801.mat');%
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174912.mat');
%load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_175015.mat');
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk

fname = sprintf('20130919_153029');  % good candidate: 20130919_151314

load([fname, '.mat']);


%% process EMG
t_bic= data_bic(:,1);
t_tri= data_tri(:,1);
length_bic = data_bic(:,2);
length_tri = data_tri(:,2);
Ia_afferent_bic = data_bic(:,3);
II_afferent_bic = data_bic(:,4);
Ia_afferent_tri = data_tri(:,3);
II_afferent_tri = data_tri(:,4);
f_emg_bic = data_bic(:,6);
f_emg_tri = data_tri(:,6);
force_bic = data_bic(:,5);
force_tri = data_tri(:,5);
MN1_spikes_bic = data_bic(:,7);
MN2_spikes_bic = data_bic(:,8);
MN3_spikes_bic = data_bic(:,9);
MN4_spikes_bic = data_bic(:,10);
MN5_spikes_bic = data_bic(:,11);
MN6_spikes_bic = data_bic(:,12);




n = 3;
start =100;
%start = 1250;
last = min(length(t_bic), 22000); 
% last = min(length(t_bic), 1000); %2050
subplot(n, 1, 1);


[pks,high_locs] = findpeaks(length_bic)
length_bic_inverted = -length_bic;
[~,low_locs] = findpeaks(length_bic_inverted)

%% 


%% EMG processing
Fe=33; %Samling frequency
Fc_lpf=1.0; % Cut-off frequency
Fc_hpf=0.5;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic=filtfilt(D, C, f_emg_bic); %in the case of Off-line treatment
f_rec_emg_bic = abs(EMG_high_bic);  % rectify
EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment

EMG_high_tri=filtfilt(D, C, f_emg_tri); %in the case of Off-line treatment
f_rec_emg_tri = abs(EMG_high_tri);  % rectify
EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment

%%
figure_width  = 8*2;
figure_height = 6*2;
FontSize = 11*1.5;
FontName = 'MyriadPro-Regular';

hold on
hfig  = figure(1); 

    set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 


% axis off;  
hLine1 = line(t_bic(start:last), length_bic(start:last));
% hdots_high = line(t_bic(high_locs),length_bic(high_locs));
% hdots_low = line(t_bic(low_locs),length_bic(low_locs));
 
set(hLine1                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
set(gca,'YLim',[0.85 1.5])
hYLabel = ylabel('flexor length');

% hTitle  = title ('extra cortical drive scale: 7 ');
% hTitle  = title ('flexor muscle length. High Trascortical reflex gain: 3 ');

subplot (n,1, 2);
hLine2 = line(t_bic(start:last), f_emg_bic(start:last));
set(hLine2                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 2           , ...   
  'Color'           , 'black'  );
axis off;


subplot (n,1, 3);
hLine3 = line(t_bic(start:last), force_bic(start:last));
set(hLine3                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
% set(gca,'YLim',[0 200])
% axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('flexor force');

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

% % %% velocity
% subplot (n,1, 4);
% hLine8 = line(t_bic(start:last), vel_bic(start:last));
% set(hLine8                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('vel');



%%
hfig2  = figure(2); 
last = min(length(t_tri), 22000) 
set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 

subplot(n, 1, 1);
hLine4 = line(t_tri(start:last), length_tri(start:last));
set(hLine4                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
% set(gca,'YLim',[0.55 1.1])
set(gca,'YLim',[0.65 1.2])
hYLabel = ylabel('Extensor length');

subplot (n,1, 2);
hLine5 = line(t_tri(start:last), f_emg_tri(start:last));
set(hLine5                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 2           , ...   
  'Color'           , 'black'  );
axis off;

subplot (n,1, 3);
hLine6 = line(t_tri(start:last), force_tri(start:last));
set(hLine6                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black');
axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('Extensor force');


% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_tri)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_tri(start:last), extraCN(start:last));
% hYLabel  = ylabel('extra drive');
% 
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [.1 .4 .4]  );
% set(gca,'YLim',[0 10])
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
print(hfig, '-dpng', [fname, '_perturb_bic']);
print(hfig2, '-dpng', [fname, '_perturb_tri']);

% -dpng 

%% Raster plot
MN1_spikeindex=[]; 
MN2_spikeindex=[];
MN3_spikeindex=[];
MN4_spikeindex=[];
MN5_spikeindex=[];
MN6_spikeindex=[];

binaryMN1 = dec2bin(MN1_spikes_bic);
binaryMN2 = dec2bin(MN2_spikes_bic);
binaryMN3 = dec2bin(MN3_spikes_bic);
binaryMN4 = dec2bin(MN4_spikes_bic);
binaryMN5 = dec2bin(MN5_spikes_bic);
binaryMN6 = dec2bin(MN6_spikes_bic);
[r,c] = size(binaryMN1);  % 761, 32


numofrow = 3;
for i=1:r*numofrow,  % get two rows for each MN
    if binaryMN1(i) =='1'
        MN1_spikeindex = [MN1_spikeindex i]; 
    end
    if binaryMN2(i) =='1'
        MN2_spikeindex = [MN2_spikeindex i]; 
    end
    if binaryMN3(i) =='1'
        MN3_spikeindex = [MN3_spikeindex i]; 
    end
    if binaryMN4(i) =='1'
        MN4_spikeindex = [MN4_spikeindex i]; 
    end
    if binaryMN5(i) =='1'
        MN5_spikeindex = [MN5_spikeindex i]; 
    end
%     if binaryMN6(i) =='1'
%         MN6_spikeindex = [MN6_spikeindex i]; 
%     end
%     
end


allMN_raster = [MN1_spikeindex (r*numofrow*1)+MN2_spikeindex (r*numofrow*2)+MN3_spikeindex (r*numofrow*3)+MN4_spikeindex (r*numofrow*4)+MN5_spikeindex (r*numofrow*5)+MN6_spikeindex];


rasterplot(allMN_raster, numofrow*6, r);axis off    








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


