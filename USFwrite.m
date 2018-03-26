%% 将滤波后的电压值数据存入新建的USF文件
%% filein  原USF文件
%% fileout 新建的USF文件
%% V_str   滤波后的电压值数据，类型为char
%% 程序如下：
function USFwrite(filein,fileout,V_str)
%% 初始化
fclose('all');
fidin=fopen(filein,'r');
fidout_3=fopen(fileout,'wt');
i=1;%数据行索引
%% 替换源文件的电压值数据并存入新的USF文件
while ~feof(fidin)
    tline1=fgetl(fidin);
    if isempty(tline1)
        fprintf(fidout_3,'\n');
    elseif tline1(1)=='/'        
        fprintf(fidout_3,'%s\n',tline1);
    elseif tline1(7)=='I' && tline1(8)=='N' && tline1(9)=='D'
        fprintf(fidout_3,'%s\n',tline1);
    elseif tline1(49)=='-'
        tline1(49)=' ';
        tline1([50 51 52 53 54 55 56 57 58 59 60 61])=V_str(i,:);
        i=i+1;
        fprintf(fidout_3,'%s\n',tline1);
    else
        tline1([50 51 52 53 54 55 56 57 58 59 60 61])=V_str(i,:);
        i=i+1;
        fprintf(fidout_3,'%s\n',tline1);
    end
end
fclose('all');
