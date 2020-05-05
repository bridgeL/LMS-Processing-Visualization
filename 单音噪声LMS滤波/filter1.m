%% �ú�ɾ

% ������
% ����Ӧ�˲�����1

function [out, noise_lms, w] = filter1(dirty_sig, noise_sig, n, u, w_old)
% n �˲�������
% u ѧϰ����

w = w_old;

len = length(dirty_sig);
out = zeros(1,len);
noise_lms = zeros(1,len);

% �������ڼ�Ȩ�˲�
for i = 1:len-n+1
    % �����ź�
    window_sig = noise_sig(i:i+n-1);
    
    % ��Ȩ���
    noise_lms(i) = sum(w.*window_sig);
    
    % ���
    error = dirty_sig(i) - noise_lms(i);
    out(i) = error;
    
    % w����
    w = w + u * window_sig * error;

end

    
end



