%% 用后即删

% 测试用
% 自适应滤波函数1

function [out, noise_lms, w] = filter1(dirty_sig, noise_sig, n, u, w_old)
% n 滤波器阶数
% u 学习步长

w = w_old;

len = length(dirty_sig);
out = zeros(1,len);
noise_lms = zeros(1,len);

% 滑动窗口加权滤波
for i = 1:len-n+1
    % 窗口信号
    window_sig = noise_sig(i:i+n-1);
    
    % 加权求和
    noise_lms(i) = sum(w.*window_sig);
    
    % 误差
    error = dirty_sig(i) - noise_lms(i);
    out(i) = error;
    
    % w修正
    w = w + u * window_sig * error;

end

    
end



