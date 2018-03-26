%% 读取usf文件中的数据
%% V             存放各个测点的电压值数据，存放成一列
%% T             存放各个测点的时窗数据，存放成一列
%% Point_num     存放各个测点的点号数据，存放成一列
%% Points        代表总测点数
%% sampling      代表采样时窗的个数


function [single_V,single_T,Point_num]=USFread(filein,sampling)
%% 提取文件中的点线号和数据
fidin=fopen(filein,'r');
fidout_1=fopen('T_V.txt','wt');%以‘wt’方式打开txt文件
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
%% 提取各测点的电压值数据组成数组
%% 每一列代表一个测点的全部电压值数据
single_V=zeros(sampling,Points);
for i=1:1:sampling
    for j=1:Points
        single_V(i,j)=V(i+40*(j-1));
    end
end
%% 提取各测点的时窗数据组成数组
%% 每一列代表一个测点的全部时窗数据
single_T=zeros(sampling,Points);
for i=1:1:sampling
    for j=1:Points
        single_T(i,j)=T(i+40*(j-1));
    end
end
%% end


