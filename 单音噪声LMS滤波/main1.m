%% �ú�ɾ

% ������
% �����Ҳ���ϡ�����Ӧ�˲�����

% ���ۣ��˴���ɽ��������������Ӧ�˲����⣬�����������˲���������ù�ϵ

% ��ͼ׼��
figure_handle1 = figure(1);
fh1_axes1 = subplot(311);
fh1_axes2 = subplot(312);
fh1_axes3 = subplot(313);
figure_handle2 = figure(2);
fh2_axes1 = subplot(311);
fh2_axes2 = subplot(312);
fh2_axes3 = subplot(313);

% �ź�Ԥ��
freq = [ 10, 10.01 ];
phase = [ 0, pi/2 ];
amp = [ 10, 10 ];
% shape_out_vpp = 5;

group_delay = 1.3;

% LMS�����������ޣ���������ʱ��LMS�˲������ݲ�Ч������
% LMS������������ ����Ƶ��(�����)�͹���Ƶ�ʣ�����أ� Ӱ��
w_num = 10;
w_old = zeros(1,w_num);

% ����Ԥ��
fs = 1e3;
T = 1e4; % 20 * n

% ������׼��
n = T / 20;                 % �����ݷ�n�Σ���ʱչʾ
N = T * fs + n * w_num; % �ܹ���Ҫ���������ݵ�����������ظ���
N_div = N / n;          % ÿ���������
N_div_new = N_div - w_num; % ÿ���������� �϶����������� + ���������

for i = 1:n
    % ����ʱ������
    % ����ÿһ����������ĩβw_num���㲻�ܱ�filter��Ӧ������һ������������ʱ��
    % Ӧ���°�����һ����������ĩβ���֣��Է�ֹ����ĳ����Ӧ
    
    sample_t = (1:N_div) + N_div_new * (i-1);
    sample_t = sample_t / fs;
    
    % ���ɴ����źš�����Ⱦ�źš������źš������������ź�
    [clear_sig, dirty_sig, noise_sig1, noise_sig2] = main1_sub(freq, phase, amp,group_delay, sample_t);
    
    % 100��LMS�˲�
    % ���뱻��Ⱦ�źź������źţ����LMS�Ʋ�������������ź�
    u = 1e-8;
%     u = 1e-5 * shape_out_vpp;
%     u = 1e-5 / noise_sig1_vpp * error_vpp;
%      u = 6e-7 - 1e-8 * i; 
%     ��ʽЧ������exp�ã��Ʋ�ԭ��Ϊ 1/t�����Լ���һ�׵�����˥������
%     u = 1e-6 * exp(-i/20);
%     ��ʽЧ������error_vpp�ã���Ϊt�������������û��ֱ����ϵ��ʹ��t��صĺ�����ָ��ѧϰ�����Ƿ����Ե�
%     u = 1e-5 * error_vpp;
%     ��ʽ�޷���ȫ�������ҷ�ֵ��������˥������Ϊѧϰ��������error_vpp�������һ��ʼ��û�н����ȶ���������ʱerror_vpp�в�����ָ������
%     ��������źŰ������Ҫ�󲻸ߵ�����¿�ѡ����ʽ
%     u = 1e-6 * error_vpp;
%     ��ʵ�飬��ʽ��ʼuֵѡȡ�������źŷ��ȣ�����أ�Ӱ��
    
    % �˲�
    [out, noise_lms, w] = filter1(dirty_sig, noise_sig1, w_num, u, w_old);
    w_old = w;
    
    % error vpp
    error = noise_lms(1:1e3) - noise_sig2(1:1e3);
    error_vpp = max(error) - min(error);
    
    % ����
    shape_out = abs(hilbert(out));
    m = (1e3:2e3);
    shape_out_vpp = max(shape_out(m)) - min(shape_out(m));
    
    % ��ͼ
    plot(fh1_axes1,w);
    title(fh1_axes1,[num2str(w_num),'��w�ֲ�    ','u = ' , num2str(u)]);
    
    m = (1:N_div_new);
    plot(fh1_axes2,sample_t(m),out(m),sample_t(m),shape_out(m));
    title(fh1_axes2,['�˲����ź��Լ������   ������� ',num2str(shape_out_vpp),'   time:',num2str(i)]);
    
    m = (1:2e2);
    plot(fh1_axes3,sample_t(m),out(m),sample_t(m),shape_out(m));
    title(fh1_axes3,'�ֲ�ͼ');

    plot(fh2_axes1,error);
    title(fh2_axes1,['error vpp = ' , num2str(error_vpp)]);
    
    m = (1:N_div_new);
    plot(fh2_axes2,sample_t(m),noise_lms(m),sample_t(m),noise_sig2(m),':');
    title(fh2_axes2,'LMSģ�������ź���Ⱥ��ʱ�������źŶԱ�');
    
    m = (1:1e2);
    plot(fh2_axes3,sample_t(m),noise_lms(m),sample_t(m),noise_sig2(m),':'); 
    title(fh2_axes3,'�ֲ�ͼ');
     
    pause(0.01);
    
%     if strcmpi(get(gcf,'CurrentCharacter'),'e')
%         break;
%     end
end
