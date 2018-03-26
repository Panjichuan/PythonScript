%% 瞬变电磁数据预处理
%% filein        usf文件名
%% V             存放各个测点的电压值数据，存放成一列
%% T             存放各个测点的时窗数据，存放成一列
%% Point_num     存放各个测点的点号数据，存放成一列
%% Points        代表总测点数
%% sampling      代表采样数
clc
clear all
%% 提取文件中的数据
filein='172_p_3.5.USF';
fileout='172_p_3.5_f.USF';
sampling=40;
[V,T,Point_num]=USFread(filein,sampling);
Points=length(Point_num);
%% 原始数据衰减曲线
figure(1)
for i=1:Points
    loglog(T(:,i),abs(V(:,i)))
    hold on
end
%% 小波滤波
V_f=zeros(sampling,Points);
for i=1:Points
    V_f(:,i)=wavelet(V(:,i));
end
%% 小波滤波数据衰减曲线
% figure(2)
% for i=1:Points
%     loglog(T(:,i),abs(V_f(:,i)))
%     hold on
% end
%% 测道圆滑处理
V_smooth=zeros(sampling,Points);
for i=1:Points
    V_smooth(:,i)=curve_smooth(T(:,i),V(:,i));    
end
figure(3)
for i=1:Points
    loglog(T(:,1),abs(V_smooth(:,i)))
    hold on
end
%% 测点圆滑处理
V_Final=zeros(sampling,Points);
C0=80;%圆滑系数
for i=1:sampling
    V_Final(i,:)=Point_smooth(T(:,1),V_smooth(i,:),C0);
end
%% 绘制多测道剖面图
figure(4)
multi_curve(sampling,Point_num,V_Final)
%% 电压数据转换为字符串
V_str=transform(V_Final,Points);
USFwrite(filein,fileout,V_str);