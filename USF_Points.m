%% 统计文件中测点的个数
function Points=USF_Points(filein)
fidin=fopen(filein);
Points=0;
while ~feof(fidin)
    tline=fgetl(fidin);
    if ~isempty(tline)
        if tline(1)=='/'&&tline(2)=='L'&&tline(3)=='O'&&tline(4)=='C'
            Points=Points+1;
        end
    end
end
fclose(fidin);