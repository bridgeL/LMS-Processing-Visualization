%% �ú�ɾ

% ������
% �����Ҳ���ϡ�����Ӧ�˲�����

% ����ʱ������
sample_t = 0:1e-6:1;
%% �ź�������
freq1 = 10e3;

clear_sig = signal(freq1, 0, 1, sample_t);

%% ��������������
freq2 = 20e3;

mix_n = (1:3);
mix_freq = mix_n * freq2;
mix_phase = zeros(1,length(mix_n));
mix_amp = ones(1,length(mix_n));

% ����Ⱥʱ�ӷ��ı��ź���λ
group_delay = 1e-5;
noise_sig = signal(mix_freq, mix_phase, mix_amp, sample_t + group_delay);
plot(sample_t,noise_sig);

%% ���
dirty_sig = clear_sig + noise_sig;
plot(sample_t,dirty_sig);

%% �˲�






