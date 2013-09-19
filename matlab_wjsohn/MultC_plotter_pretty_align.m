
close all;
%      clc; clear;close all;
%   load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174406.mat');  %
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174627.mat');%
%  load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174801.mat');%
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174912.mat');
%load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_175015.mat');
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk


cursor_info = sprintf('cursor_info');  % scaler 20130829_114414
load([cursor_info, '.mat']); 
for k = 1:1
  %% process EMG

  if k==1
      fname1 = sprintf('20130829_114414');  % scaler 20130829_114414
      load([fname1, '.mat']); 
  elseif (k==2)
      fname2 = sprintf('20130829_105922');  % scaler 20130829_105922
      load([fname2, '.mat']);
  end

n = 3;
start =300;
%start = 1250;
last =12500;
offset = 480;

t_bic= data_bic(:,1);
t_tri= data_tri(:,1);
length_bic = data_bic(:,2);
length_tri = data_tri(:,2);
vel_bic = data_bic(:,3);
vel_tri = data_tri(:,3);
f_emg_bic = data_bic(:,6);
f_emg_tri = data_tri(:,6);
force_bic = data_bic(:,5);
force_tri = data_tri(:,5);
    
if (k == 1)
    t_bic_cut= t_bic(start:last);
    t_tri_cut= t_tri(start:last);
    length_bic_cut = length_bic(start:last);
    length_tri_cut = length_tri(start:last);
    f_emg_bic_cut = f_emg_bic(start:last);
    f_emg_tri_cut = f_emg_tri(start:last);
    force_bic_cut = force_bic(start:last);
    force_tri_cut = force_tri(start:last);

else
    start = start + offset;
    last = last + offset;
%     t_bic= t_bic(start:last);
%     t_tri= t_tri(start:last);
    length_bic_offset = length_bic(start:last);
    length_tri_offset = length_tri(start:last);
    f_emg_bic_offset = f_emg_bic(start:last);
    f_emg_tri_offset = f_emg_tri(start:last);
    force_bic_offset = force_bic(start:last);
    force_tri_offset = force_tri(start:last);
end


% last = min(length(t_bic), 1000); %2050


[pks,high_locs] = findpeaks(length_bic)
length_bic_inverted = -length_bic;
[~,low_locs] = findpeaks(length_bic_inverted)



%% EMG processing
% Fe=33; %Samling frequency
Fe = 145;
Fc_lpf=2.0; % Cut-off frequency
Fc_hpf=1.0;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic_cut=filtfilt(D, C, f_emg_bic_cut); %in the case of Off-line treatment
f_rec_emg_bic_cut = abs(EMG_high_bic_cut);  % rectify
EMG_bic_cut=filtfilt(B, A, f_rec_emg_bic_cut); %in the case of Off-line treatment

EMG_high_tri_cut=filtfilt(D, C, f_emg_tri_cut); %in the case of Off-line treatment
f_rec_emg_tri_cut = abs(EMG_high_tri_cut);  % rectify
EMG_tri_cut=filtfilt(B, A, f_rec_emg_tri_cut); %in the case of Off-line treatment

figure;
[z,p,k] = butter(N,Fc_lpf*2/Fe,'low');
% [z,p,k]= butter(N,Fc_hpf*2/Fe,'high')
[sos,g] = zp2sos(z,p,k);      % Convert to SOS form
Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
h = fvtool(Hd);              % Plot magnitude response
set(h,'Analysis','freq')      % Display frequency response 


%%% off set data
if (k ==2) 
    EMG_high_bic_offset=filtfilt(D, C, f_emg_bic_offset); %in the case of Off-line treatment
    f_rec_emg_bic_offset = abs(EMG_high_bic_offset);  % rectify
    EMG_bic_offset=filtfilt(B, A, f_rec_emg_bic_offset); %in the case of Off-line treatment

    EMG_high_tri_offset=filtfilt(D, C, f_emg_tri_offset); %in the case of Off-line treatment
    f_rec_emg_tri_offset = abs(EMG_high_tri_offset);  % rectify
    EMG_tri_offset=filtfilt(B, A, f_rec_emg_tri_offset); %in the case of Off-line treatment
end



hfig = figure(1);
n=3;
subplot(n, 1, 1);

xCursor=zeros(length(cursor_info), 1);
yCursor=zeros(length(cursor_info), 1);
if (k == 2)
    plot(t_bic_cut, length_bic_offset,'--', 'LineWidth',2);
else
    plot(t_bic_cut, length_bic_cut, 'LineWidth',2);    
%     [pks, locs] = findpeaks(length_bic_cut);
%     hold on
    % showing the peaks (manually acquired)  
    for i = 1:length(cursor_info)
        hold on
        xCursor(i)=cursor_info(1, i).Position(1);
        yCursor(i)=cursor_info(1, i).Position(2); 
        plot(xCursor(i),yCursor(i), 'r+');
    end
end
ylim([0.7 1.3])
% legend('biceps length');
% grid on
axis off
hold on
grid on
% 
subplot(n, 1, 2);
if (k == 2)
    plot(t_bic_cut, EMG_bic_offset, '--', 'LineWidth',2);
else     
    plot(t_bic_cut, EMG_bic_cut);
end
% legend('full wave rect biceps emg');
% grid on
ylim([-0.5 3.5]);
axis off
hold on
grid on

subplot(n, 1, 3);
if (k == 2)
    plot(t_bic_cut, force_bic_offset, '--', 'LineWidth',2);
else
    plot(t_bic_cut, force_bic_cut, 'LineWidth',2);
end
 % legend('force bicpes');
% grid on
axis off
hold on
grid on

hfig2 = figure(2);
n=3;
subplot(n, 1, 1);

if (k == 2)
    plot(t_tri_cut,  length_tri_offset, '--', 'LineWidth',2);
else
    plot(t_tri_cut, length_tri_cut, 'LineWidth',2);
end
    % legend('triceps length');
ylim([0.7 1.3])
% grid on
axis off
hold on
grid on
% 
subplot(n, 1, 2);
if (k == 2)
    plot(t_tri_cut, EMG_tri_offset, '--', 'LineWidth',2);
else    
    plot(t_tri_cut, EMG_tri_cut);
end
% legend('full wave rect triceps emg');
% grid on
%ylim([-0.5 3.5]);
% ylim([0 40])
axis off
hold on
grid on
subplot(n, 1, 3);
if (k == 2)
    plot(t_tri_cut, force_tri_offset, '--', 'LineWidth',2);
else 
    plot(t_tri_cut, force_tri_cut, 'LineWidth',2);
end
% legend('force triceps');
% grid on
axis off
grid on
hold on
title('trial5, CN simple general, 20130824__174839/ 20130824__174958'); 
end


%%  

  


%% save figure
%print(hfig, '-dpng', (['figure' num2str(date),  datestr(now, '  HH:MM:SS')]);
% 
% fname = sprintf('myfile%d.mat', i);

print(hfig, '-dpng', [fname1, '_bic']);
print(hfig2, '-dpng', [fname1, '_tri']);

%-dpng 


%% statistical analysis



% % xcorr demo
% %
% % The signals
% figure;
% t = [0:127]*0.02;
% f = 1.0;
% s1 = sin(2*pi*f*t);
% s2 = sin(2*pi*f*(t-0.35)); % s1 lags s2 by 0.35s
% subplot(2,1,1);
% plot(t,s1,'r',t,s2,'b');
% grid
% title('signals')
% %
% % Now cross-correlate the two signals
% %
% x = xcorr(s1,s2,'coeff');
% tx = [-127:127]*0.02;
% subplot(2,1,2)
% plot(tx,x)
% grid
% %
% % Determine the lag
% %
% figure;
% [mx,ix] = max(x);
% lag = tx(ix);
% hold on
% tm = [lag,lag];
% mm = [-1,1];
% plot(tm,mm,'k')
% hold off

%%
% figure;
% a = fft(length_bic_cut);
% b = fft(length_bic_offset);
% 
% 
% plot(abs(angle(a) - angle(b)));
% averagePA=mean(abs(angle(a) - angle(b))); 
% averagePA = averagePA/3.141592*360
% 
% 
% figure;
% [c, lags] = xcorr(length_bic_cut, length_bic_offset, 'coeff');
% subplot(4, 1, 1);
% plot(t_bic_cut, length_bic_cut, 'b', t_bic_cut, length_bic_offset, 'r');
% % xc = [2.0395:0.0067/2:85];
% subplot(4, 1, 2);
% 
% [mx, ix]= max(c)
% t_bic_cut(ix)
% plot(c);
% 
% subplot(4, 1, 3);
% plot(lags);
% 
% subplot(4, 1, 4);
% stem(lags, c);



%%  interpolation

figure;
% subplot(3, 1, 1);
% plot(t_bic_cut, length_bic_cut);
% y = sin(2.3*t_bic_cut);
% subplot(3, 1, 1);
% plot(t_bic_cut,y);
% subplot(3, 1, 1);
% 
% xx = 2:0.0067:85; 
% xx_pre = transpose(xx);
% xx = xx_pre(1:length(t_bic_cut));
% 
% 
% yy = spline(xCursor, yCursor, xx);
% plot(xx, yy);
subplot(3, 1, 1);
% yy=spline(t_bic_cut, , x);    % cubic spline interpolation
% plot(ppval(cs, xx));

a = unique(xCursor);

t_step=200;

t_interp = [];
len_interp = [];
EMG_interp = [];
for i = 1:length(cursor_info)-1
    ind_temp =  find(t_bic_cut == a(i));
%     ind = [ind ind_temp];
    if i == 1
        t_interp_temp = 2:(a(i)-2)/(t_step-1):a(i);
        len_interp_temp=interp1(t_bic_cut(1:ind_temp),length_bic_cut(1:ind_temp),t_interp_temp);
        EMG_interp_temp=interp1(t_bic_cut(1:ind_temp),EMG_bic_cut(1:ind_temp),t_interp_temp);
    else
        t_interp_temp = a(i-1):(a(i)-a(i-1))/(t_step-1):a(i);
        ind = find(t_bic_cut == a(i))
        ind_prev = find(t_bic_cut == a(i-1))
        len_interp_temp=interp1(t_bic_cut(ind_prev+1:ind_temp),length_bic_cut(ind_prev+1:ind_temp),t_interp_temp);
        EMG_interp_temp=interp1(t_bic_cut(ind_prev+1:ind_temp),EMG_bic_cut(ind_prev+1:ind_temp),t_interp_temp);
    end  
    
    t_interp = [t_interp t_interp_temp];
    len_interp = [len_interp len_interp_temp];
    EMG_interp=[EMG_interp EMG_interp_temp];
end



plot(t_interp, len_interp, 'k', 'LineWidth',2);
axis off
subplot(3, 1, 2);
t_new = linspace(2, 85, 10800);
plot(t_new, len_interp, 'k',  'LineWidth',2);
axis off
subplot(3, 1, 3);
plot(t_new, EMG_interp, 'k',  'LineWidth',2);
axis off


%% correlation analysis

len_interp = len_interp - mean(len_interp(~isnan(len_interp)));   % remove bias
EMG_interp = EMG_interp - mean(EMG_interp(~isnan(EMG_interp)));   % remove bias

[rho, pval] = corr(transpose(len_interp(~isnan(len_interp))), transpose(EMG_interp(~isnan(EMG_interp))))
 

%  [c, lags] = xcorr(transpose(len_interp(~isnan(len_interp))), transpose(EMG_interp(~isnan(EMG_interp))));
[c, lags] = xcorr(transpose(len_interp(~isnan(len_interp))), transpose(EMG_interp(~isnan(EMG_interp))));

 figure;
%  c = c(length(c)/2:end);
 subplot(2,1,1);
%  plot(c,'k');
 plot(lags, c);
%  stem(lags, c);
subplot(2,1,2);plot(lags,'k');

%% piecewise cross correlation 


  
% remove bias

% 
% Fs = 150; % Sampleing frequency
% nfft=1024; % length of FFT
% fft_len= fft(len_interp(~isnan(len_interp)), nfft);
% fft_len = fft_len(1:nfft/2); % FFT is symmetric
% p = unwrap(angle(fft_len));
% f = (0:nfft/2-1)*(Fs/nfft); %/length(fft_len)*100;  % freq vector
% figure;plot(f, p*180/pi); 
% xlabel('Frequency (Hz)')
% ylabel('Phase (Degrees)')


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


