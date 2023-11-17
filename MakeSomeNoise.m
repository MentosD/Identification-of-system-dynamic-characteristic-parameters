clear

m = 3;
c = 4;
k = 10;


% 参数设置
fs = 1000;          % 采样率 1000Hz
t = 0:1/fs:60-1/fs; % 时间向量，持续60秒
n = length(t);       % 样本数量

% 生成白噪声
noise = randn(1, n); % 生成标准正态分布随机数

% 设计更高阶的低通滤波器以限制频率至30Hz
f_cutoff = 30; % 截止频率30Hz
f_norm = f_cutoff/(fs/2); % 归一化截止频率
filter_order = 8; % 提高滤波器的阶数
[b, a] = butter(filter_order, f_norm, 'low'); % 使用更高阶的巴特沃斯滤波器

% 应用滤波器
filtered_noise = filter(b, a, noise);

% 调整幅值范围至最大为1
max_val = max(abs(filtered_noise));
scaled_noise = filtered_noise / max_val;

% 使用pwelch估计功率谱密度
[pxx, f] = pwelch(scaled_noise, hann(n/4), [], [], fs);

% 绘制功率谱
figure;
plot(f, 10*log10(pxx), 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of the White Noise Signal');
grid on;

% 标记30Hz的截止频率
line([30 30], ylim, 'Color', 'red', 'LineStyle', '--');
legend('Power Spectral Density', '30 Hz Cutoff');

whitenoise = [t' scaled_noise']; % 将时间向量和scaled_noise合并为两列
