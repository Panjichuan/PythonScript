function V=wavelet(V)
%% 小波分解
[c,l]=wavedec(V,1,'sym6');
%利用小波‘db6’对xn信号进行1层分解，求得的近似系数存放在c中，细节系数存放在a中
a1=appcoef(c,l,'sym6',1);%提取一维小波变换低频系数，
d1=detcoef(c,l,1);%提取一维小波变换高频系数，1尺度的高频系数
%根据‘sqtwolog’定义的阈值选择信号d1的自适应阈值
thr1=thselect(d1,'sqtwolog');

%% 硬阈值去噪
%使用硬阈值‘h’（软阈值‘s’）thr1对信号d1进行去噪
hd1=wthresh(d1,'s',thr1);
c1=[a1;hd1];
V=waverec(c1,l,'sym6');
