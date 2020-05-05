function out = signal( freq, phase, amp, t)
% 生成一组频率、相位、振幅不同的正弦信号的合成波
% freq 频率数组
% phase 相位数组
% amplitude 振幅数组
% t 采样时间序列

num = length(freq);
% num 正弦信号个数


out = zeros(1,length(t));

for i = 1:num
   out =  out + amp(i) * sin( 2*pi*freq(i)*t + phase(i));
end

% % 输出为振幅归一化的信号
% out = out / sum(amp);

end
