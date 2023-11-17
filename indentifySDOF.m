
% % 生成随机输入信号 x
Fs = 1000; % 采样频率
x = out.x;
y = out.y;
% 使用系统识别工具箱中的函数
data = iddata(y, x, 1/Fs); % 创建系统数据对象

% 估计传递函数，固定分子的1阶和0阶系数
model = tfest(data, 2, 2);
% 显示辨识结果
present(model);

% 提取模型参数
[num, den] = tfdata(model, 'v'); % 提取传递函数的分子和分母

% 手动设置分子的1次项和0次项为0
num(1:end-2) = 0;

% 创建新的传递函数模型
manual_tf = tf(num, den);

% 计算传递函数模型的时程响应
time = (0:length(y)-1)/Fs; % 时间向量
y_tf = lsim(manual_tf, x, time);


% 计算系统的极点
poles = roots(den);

% 计算辨识得到的自然频率和阻尼比
wn_est = abs(poles);
zeta_est = -real(poles)./wn_est;

% 计算自然频率(wn)和阻尼比(zeta)
wn = sqrt(k/m);
zeta = c/(2*sqrt(m*k));


% 显示辨识得到的自然频率和阻尼比
fprintf('辨识得到的自然频率: %f Hz\n', wn_est/(2*pi));
fprintf('辨识得到的阻尼比: %f\n', zeta_est);

% 显示真实的自然频率和阻尼比
fprintf('真实的自然频率: %f Hz\n', wn/(2*pi));
fprintf('真实的阻尼比: %f\n', zeta);

% 绘制实际输出 y 和计算得到的输出 y_tf 的图形进行比较
figure;
subplot(2,1,1);
plot(time, y, 'b', time, y_tf, 'r--');
title('实际输出和传递函数计算输出的比较');
xlabel('时间 (s)');
ylabel('输出');
legend('实际输出', '传递函数输出');

subplot(2,1,2);
plot(time, y - y_tf, 'k');
title('误差');
xlabel('时间 (s)');
ylabel('输出误差');

%%
% 计算原始系统的频率响应
X = fft(x);
Y = fft(y);
H = Y ./ X; % 系统的频率响应

% 计算频率向量
n = length(x); % 信号长度
f = (0:n-1)*(Fs/n); % 频率范围
half_n = ceil(n/2);

% 只取一半的频率范围（Nyquist频率之前的部分）
H = H(1:half_n);
f = f(1:half_n);

% 计算幅度和相位
magnitude = 20*log10(abs(H));
phase = unwrap(angle(H)) * (180/pi);

% 绘制原始系统的Bode图
figure;
subplot(2,1,1);
semilogx(f, magnitude, 'b'); % 使用蓝色绘制原始系统的幅度响应
hold on; % 保持图形

% 绘制辨识得到的传递函数的幅度响应
[mag,~,wout] = bode(manual_tf);
mag = squeeze(20*log10(mag)); % 将幅度转换为dB
semilogx(wout/(2*pi), mag, 'r--'); % 使用红色虚线绘制辨识得到的传递函数的幅度响应
title('Bode图比较 - 幅度响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
legend('原始系统', '辨识得到的传递函数');
hold off; % 释放图形

subplot(2,1,2);
semilogx(f, phase, 'b'); % 使用蓝色绘制原始系统的相位响应
hold on; % 保持图形

% 绘制辨识得到的传递函数的相位响应
[~,phase,wout] = bode(manual_tf);
phase = squeeze(phase); % 将相位转换为度
semilogx(wout/(2*pi), phase, 'r--'); % 使用红色虚线绘制辨识得到的传递函数的相位响应
title('Bode图比较 - 相位响应');
xlabel('频率 (Hz)');
ylabel('相位 (度)');
legend('原始系统', '辨识得到的传递函数');
hold off; % 释放图形
