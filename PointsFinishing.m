%% ˲��������Ԥ����
%% filein        usf�ļ���
%% V             ��Ÿ������ĵ�ѹֵ���ݣ���ų�һ��
%% T             ��Ÿ�������ʱ�����ݣ���ų�һ��
%% Point_num     ��Ÿ������ĵ�����ݣ���ų�һ��
%% Points        �����ܲ����
%% sampling      ���������
clc
clear all
%% ��ȡ�ļ��е�����
filein='172_p_3.5.USF';
fileout='172_p_3.5_f.USF';
sampling=40;
[V,T,Point_num]=USFread(filein,sampling);
Points=length(Point_num);
%% ԭʼ����˥������
figure(1)
for i=1:Points
    loglog(T(:,i),abs(V(:,i)))
    hold on
end
%% С���˲�
V_f=zeros(sampling,Points);
for i=1:Points
    V_f(:,i)=wavelet(V(:,i));
end
%% С���˲�����˥������
% figure(2)
% for i=1:Points
%     loglog(T(:,i),abs(V_f(:,i)))
%     hold on
% end
%% ���Բ������
V_smooth=zeros(sampling,Points);
for i=1:Points
    V_smooth(:,i)=curve_smooth(T(:,i),V(:,i));    
end
figure(3)
for i=1:Points
    loglog(T(:,1),abs(V_smooth(:,i)))
    hold on
end
%% ���Բ������
V_Final=zeros(sampling,Points);
C0=80;%Բ��ϵ��
for i=1:sampling
    V_Final(i,:)=Point_smooth(T(:,1),V_smooth(i,:),C0);
end
%% ���ƶ�������ͼ
figure(4)
multi_curve(sampling,Point_num,V_Final)
%% ��ѹ����ת��Ϊ�ַ���
V_str=transform(V_Final,Points);
USFwrite(filein,fileout,V_str);