%% ��ȡusf�ļ��е�����
%% V             ��Ÿ������ĵ�ѹֵ���ݣ���ų�һ��
%% T             ��Ÿ�������ʱ�����ݣ���ų�һ��
%% Point_num     ��Ÿ������ĵ�����ݣ���ų�һ��
%% Points        �����ܲ����
%% sampling      �������ʱ���ĸ���


function [single_V,single_T,Point_num]=USFread(filein,sampling)
%% ��ȡ�ļ��еĵ��ߺź�����
fidin=fopen(filein,'r');
fidout_1=fopen('T_V.txt','wt');%�ԡ�wt����ʽ��txt�ļ�
fidout_2=fopen('location.txt','wt');    
while ~feof(fidin)
    tline=fgetl(fidin);
    if ~isempty(tline)
        if tline(1)=='/'&&tline(2)=='L'&&tline(3)=='O'&&tline(4)=='C'
            fprintf(fidout_2,'%s\n\n',tline);
        end
        if tline(1)~='/'
            if tline(7)~='I'
                fprintf(fidout_1,'%s\n\n',tline);
                continue
            end
        end
    end
end
VT_data=importdata('T_V.txt');
V=VT_data(:,4);
T=VT_data(:,2);
[~,y,~]=textread('location.txt','/LOCATION: %n %n %f','delimiter',','); %#ok<REMFF1>
Point_num=y;
fclose all;
delete *.txt;
Points=length(Point_num);
%% ��ȡ�����ĵ�ѹֵ�����������
%% ÿһ�д���һ������ȫ����ѹֵ����
single_V=zeros(sampling,Points);
for i=1:1:sampling
    for j=1:Points
        single_V(i,j)=V(i+40*(j-1));
    end
end
%% ��ȡ������ʱ�������������
%% ÿһ�д���һ������ȫ��ʱ������
single_T=zeros(sampling,Points);
for i=1:1:sampling
    for j=1:Points
        single_T(i,j)=T(i+40*(j-1));
    end
end
%% end


