%% �ú�ɾ

% ������
% ���Ҳ��ͷ�����ϡ�����Ӧ�˲�����

freq1 = 10e3;
freq2 = 10.01e3;

fs = 1e6;
T = 1;
n = 50;

w_num = 100;
w_old = zeros(1,w_num);

vpp = 2;

group_delay = 2e-5;
amp2 = 1;

for i = 1:n
    % ����ʱ������
    sample_t = (1/fs : 1/fs : T/n) + T/n * (i-1);
    
    % ���ɴ����źš�����Ⱦ�źš������źš������������ź�
    [clear_sig, dirty_sig, noise_sig1, noise_sig2] = main2_sub(freq1, freq2, group_delay, amp2, sample_t);   

    % 100��LMS�˲�
    
    u = 1e-5;
%     u = 1e-5 * error_vpp;
%     ��ʽ�޷���2s����ȫ������
%     ��������źŰ������Ҫ�󲻸ߵ�����¿�ѡ����ʽ

    [out, noise_lms, w] = filter2(dirty_sig, noise_sig1, w_num, u, w_old);
    w_old = w;
    
    % ��ͼ
    figure(1);
    subplot(311);
    plot(sample_t,out);
    title(['u = ' , num2str(u)]);
    
    subplot(312);
    short_t = (1:2e2);
    plot(sample_t(short_t),out(short_t));

    subplot(313);
    plot(w);

    figure(2);
    subplot(311);
    plot(sample_t,noise_lms,sample_t,noise_sig2,':');
    title(['vpp = ' , num2str(vpp)]);
    
    subplot(312);
    short_t = (1:2e2);
    plot(sample_t(short_t),noise_lms(short_t),sample_t(short_t),noise_sig2(short_t),':');
    
    subplot(313);
    short_t = (1:1e3);
    deviation = noise_lms(short_t) - noise_sig2(short_t);
    vpp = max(deviation) - min(deviation);
    plot(deviation);
     
    pause(0.01);
    
end

