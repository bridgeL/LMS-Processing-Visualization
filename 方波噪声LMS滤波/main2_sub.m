%% �ú�ɾ

% ������
% �������������Ҳ����

function [clear_sig, dirty_sig, noise_sig1, noise_sig2] = main2_sub(freq1, freq2, group_delay, amp2, sample_t)
    
% �ź�����
clear_sig =  sin( 2*pi * freq1 * sample_t );

% 9�׷�������������
mix_n = (1:2:9);
mix_freq = mix_n * freq2;
mix_phase = zeros(1,length(mix_n));
mix_amp = 1./mix_n;

noise_sig1 = amp2 * signal(mix_freq, mix_phase, mix_amp, sample_t);

% ����Ⱥʱ�ӷ��ı��ź���λ
noise_sig2 = amp2 * signal(mix_freq, mix_phase, mix_amp, sample_t + group_delay);

% ���
dirty_sig = clear_sig + noise_sig2;

end


