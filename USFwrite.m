%% ���˲���ĵ�ѹֵ���ݴ����½���USF�ļ�
%% filein  ԭUSF�ļ�
%% fileout �½���USF�ļ�
%% V_str   �˲���ĵ�ѹֵ���ݣ�����Ϊchar
%% �������£�
function USFwrite(filein,fileout,V_str)
%% ��ʼ��
fclose('all');
fidin=fopen(filein,'r');
fidout_3=fopen(fileout,'wt');
i=1;%����������
%% �滻Դ�ļ��ĵ�ѹֵ���ݲ������µ�USF�ļ�
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
