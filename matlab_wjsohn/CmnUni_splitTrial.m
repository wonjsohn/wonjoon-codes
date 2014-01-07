% dataPath = './llsr/';
dataPath='/home/eric/wonjoon_codes/matlab_wjsohn/llsr_20ms_tonic/';
% file = 'norm_rack_emg_20131125_145045.mat';
% file = 'dyst_rack_emg_20131125_143043.mat';
% file = 'norm_rack_test_20131125_145028.mat';
% file = 'dyst_rack_test_20131125_143037.mat';

file_emg = 'tonic600_rack_emg_20131213_175531.mat';
file_test = 'tonic600_rack_test_20131213_175528.mat';


fullFile_emg = [dataPath, file_emg];
fullFile_test = [dataPath, file_test];


data_emg = dataset(load(fullFile_emg));  
data_test = dataset(load(fullFile_test));  
% data.xxx = [];
dataLen = length(data_emg)
dataLen2 = length(data_test)


figure(1);
%plot(data_emg.f_emg);
plot(data_test.Ia_spindle0);

%% Split trials
iBegin = ginput(1);
iEnd = ginput(1);

trialNum = str2num(input('How many trials are there? ', 's'));
trialSize = floor(length(data_emg) / trialNum);

chunk_test = {};
iChunk_test = []

chunk_emg = {};
iChunk_emg = []

% rename time variable


for i = 1:trialNum
    iBegin = (i - 1) * trialSize + 1;
    iEnd = min(length(data_emg), iBegin + trialSize - 1);
    chunk_emg{i} = data_emg(iBegin : iEnd, : );
    
    iChunk_emg = data_emg(iBegin : iEnd, : );
%     iChunk_emg.Properties.VarNames(:,4) = 'i_time';
    
    chunk_test{i} = data_test(iBegin : iEnd, : );
    iChunk_test = data_test(iBegin : iEnd, : );
%     iChunk_test.Properties.VarNames(:,4) = 'i_time';
    
    export(iChunk_emg,'file', [dataPath, 'llsr_with_clk', num2str(i+10), '.emg']);
    export(iChunk_test,'file', [dataPath, 'llsr_with_clk', num2str(i+10), '.dat']);
end