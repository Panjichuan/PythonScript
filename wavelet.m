function V=wavelet(V)
%% С���ֽ�
[c,l]=wavedec(V,1,'sym6');
%����С����db6����xn�źŽ���1��ֽ⣬��õĽ���ϵ�������c�У�ϸ��ϵ�������a��
a1=appcoef(c,l,'sym6',1);%��ȡһάС���任��Ƶϵ����
d1=detcoef(c,l,1);%��ȡһάС���任��Ƶϵ����1�߶ȵĸ�Ƶϵ��
%���ݡ�sqtwolog���������ֵѡ���ź�d1������Ӧ��ֵ
thr1=thselect(d1,'sqtwolog');

%% Ӳ��ֵȥ��
%ʹ��Ӳ��ֵ��h��������ֵ��s����thr1���ź�d1����ȥ��
hd1=wthresh(d1,'s',thr1);
c1=[a1;hd1];
V=waverec(c1,l,'sym6');
