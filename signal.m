function out = signal( freq, phase, amp, t)
% ����һ��Ƶ�ʡ���λ�������ͬ�������źŵĺϳɲ�
% freq Ƶ������
% phase ��λ����
% amplitude �������
% t ����ʱ������

num = length(freq);
% num �����źŸ���


out = zeros(1,length(t));

for i = 1:num
   out =  out + amp(i) * sin( 2*pi*freq(i)*t + phase(i));
end

% % ���Ϊ�����һ�����ź�
% out = out / sum(amp);

end
