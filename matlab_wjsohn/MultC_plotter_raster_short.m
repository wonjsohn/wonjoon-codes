    clc; clear;close all;

cd /home/eric/nerf_verilog_eric/source/py/multC_tester

fname = sprintf('rack_emg_20130820_160849');
fname2 = sprintf('rack_test_20130820_160847');
load([fname, '.mat']);
load([fname2, '.mat']);

[r, c]=size(raster0_31_MN1)
t = 1:1:r;
last = length(t); 

MN1_spikeindex=[]; 
MN2_spikeindex=[];
MN3_spikeindex=[];
MN4_spikeindex=[];
MN5_spikeindex=[];
MN6_spikeindex=[];

binaryMN1 = dec2bin(raster0_31_MN1);
binaryMN2 = dec2bin(raster0_31_MN2);
binaryMN3 = dec2bin(raster0_31_MN3);
binaryMN4 = dec2bin(raster0_31_MN4);
binaryMN5 = dec2bin(raster0_31_MN5);
binaryMN6 = dec2bin(raster0_31_MN6);
[r,c] = size(binaryMN1);  % 761, 32


numofrow = 2;
for i=1:last*numofrow,  % get two rows for each MN
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
    if binaryMN6(i) =='1'
        MN6_spikeindex = [MN6_spikeindex i]; 
    end
    
end


allMN_raster = [MN1_spikeindex (last*numofrow*1)+MN2_spikeindex (last*numofrow*2)+MN3_spikeindex (last*numofrow*3)+MN4_spikeindex (last*numofrow*4)+MN5_spikeindex (last*numofrow*5)+MN6_spikeindex];


subplot(2, 1, 2);
rasterplot(allMN_raster, numofrow*6, last);axis off    





% axis off
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
print(hfig, '-dpng', [fname, '_raster']);
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


