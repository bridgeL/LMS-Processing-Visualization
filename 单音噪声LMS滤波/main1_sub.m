%% �ú�ɾ

% ������
% �����Ҳ����

function [clear_sig, dirty_sig, noise_sig1, noise_sig2] = main1_sub(freq, phase, amp,group_delay, sample_t)
   
freq1 = freq(1);
freq2 = freq(2);

amp1 = amp(1);
amp2 = amp(2);

phase1 = phase(1);
phase2 = phase(2);

% �źš�������������
clear_sig =  amp1 * sin( 2*pi * freq1 * sample_t + phase1 );
noise_sig1 = amp2 * sin( 2*pi * freq2 * sample_t + phase2 );

% ��������
noise_sig2 = amp2 * sin( 2*pi * freq2 * sample_t + group_delay);

% ���
dirty_sig = clear_sig + noise_sig2;

end


