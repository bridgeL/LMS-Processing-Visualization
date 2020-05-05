%% 用后即删

% 测试用
% 多正弦波混合、自适应滤波测试

% 采样时间序列
sample_t = 0:1e-6:1;
%% 信号生成器
freq1 = 10e3;

clear_sig = signal(freq1, 0, 1, sample_t);

%% 多音噪声生成器
freq2 = 20e3;

mix_n = (1:3);
mix_freq = mix_n * freq2;
mix_phase = zeros(1,length(mix_n));
mix_amp = ones(1,length(mix_n));

% 采用群时延法改变信号相位
group_delay = 1e-5;
noise_sig = signal(mix_freq, mix_phase, mix_amp, sample_t + group_delay);
plot(sample_t,noise_sig);

%% 相加
dirty_sig = clear_sig + noise_sig;
plot(sample_t,dirty_sig);

%% 滤波






