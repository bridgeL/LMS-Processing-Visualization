%% 用后即删

% 测试用
% 两正弦波混合、自适应滤波测试

% 结论，此代码可解决单音噪声自适应滤波问题，并初步分析了参数间的作用关系

% 绘图准备
figure_handle1 = figure(1);
fh1_axes1 = subplot(311);
fh1_axes2 = subplot(312);
fh1_axes3 = subplot(313);
figure_handle2 = figure(2);
fh2_axes1 = subplot(311);
fh2_axes2 = subplot(312);
fh2_axes3 = subplot(313);

% 信号预设
freq = [ 10, 10.01 ];
phase = [ 0, pi/2 ];
amp = [ 10, 10 ];
% shape_out_vpp = 5;

group_delay = 1.3;

% LMS阶数存在下限，低于下限时，LMS滤波器的陷波效果有限
% LMS阶数的下限受 采样频率(正相关)和工作频率（负相关） 影响
w_num = 10;
w_old = zeros(1,w_num);

% 采样预设
fs = 1e3;
T = 1e4; % 20 * n

% 数据流准备
n = T / 20;                 % 将数据分n段，分时展示
N = T * fs + n * w_num; % 总共需要画出的数据点个数（包含重复）
N_div = N / n;          % 每段所需点数
N_div_new = N_div - w_num; % 每段数据流由 上段数据流残余 + 新数据组成

for i = 1:n
    % 采样时间序列
    % 由于每一段数据流的末尾w_num个点不能被filter相应，当下一段数据流来临时，
    % 应重新包含上一段数据流的末尾部分，以防止额外的冲击响应
    
    sample_t = (1:N_div) + N_div_new * (i-1);
    sample_t = sample_t / fs;
    
    % 生成纯净信号、被污染信号、噪声信号、移相后的噪声信号
    [clear_sig, dirty_sig, noise_sig1, noise_sig2] = main1_sub(freq, phase, amp,group_delay, sample_t);
    
    % 100阶LMS滤波
    % 输入被污染信号和噪声信号，输出LMS推测的移相后的噪声信号
    u = 1e-8;
%     u = 1e-5 * shape_out_vpp;
%     u = 1e-5 / noise_sig1_vpp * error_vpp;
%      u = 6e-7 - 1e-8 * i; 
%     上式效果不如exp好，推测原因为 1/t函数以及其一阶导数，衰减过快
%     u = 1e-6 * exp(-i/20);
%     上式效果不如error_vpp好，因为t与收敛情况本身并没有直接联系，使用t相关的函数来指导学习步长是非理性的
%     u = 1e-5 * error_vpp;
%     上式无法完全收敛，且幅值出现严重衰减，因为学习步长过大，error_vpp的情况在一开始便没有进入稳定收敛，此时error_vpp尚不具有指导意义
%     但在输出信号包络幅度要求不高的情况下可选用上式
%     u = 1e-6 * error_vpp;
%     经实验，上式初始u值选取受噪声信号幅度（负相关）影响
    
    % 滤波
    [out, noise_lms, w] = filter1(dirty_sig, noise_sig1, w_num, u, w_old);
    w_old = w;
    
    % error vpp
    error = noise_lms(1:1e3) - noise_sig2(1:1e3);
    error_vpp = max(error) - min(error);
    
    % 包络
    shape_out = abs(hilbert(out));
    m = (1e3:2e3);
    shape_out_vpp = max(shape_out(m)) - min(shape_out(m));
    
    % 绘图
    plot(fh1_axes1,w);
    title(fh1_axes1,[num2str(w_num),'阶w分布    ','u = ' , num2str(u)]);
    
    m = (1:N_div_new);
    plot(fh1_axes2,sample_t(m),out(m),sample_t(m),shape_out(m));
    title(fh1_axes2,['滤波后信号以及其包络   包络幅度 ',num2str(shape_out_vpp),'   time:',num2str(i)]);
    
    m = (1:2e2);
    plot(fh1_axes3,sample_t(m),out(m),sample_t(m),shape_out(m));
    title(fh1_axes3,'局部图');

    plot(fh2_axes1,error);
    title(fh2_axes1,['error vpp = ' , num2str(error_vpp)]);
    
    m = (1:N_div_new);
    plot(fh2_axes2,sample_t(m),noise_lms(m),sample_t(m),noise_sig2(m),':');
    title(fh2_axes2,'LMS模拟噪声信号与群延时后噪声信号对比');
    
    m = (1:1e2);
    plot(fh2_axes3,sample_t(m),noise_lms(m),sample_t(m),noise_sig2(m),':'); 
    title(fh2_axes3,'局部图');
     
    pause(0.01);
    
%     if strcmpi(get(gcf,'CurrentCharacter'),'e')
%         break;
%     end
end
