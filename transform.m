function V_str=transform(V,Points)
for i=1:Points
    V_F(1+40*(i-1):40*i,1)=V(1:40,i);
end
a=num2str(V_F);
for i=1:length(a)
    tline=a(i,:);
    if tline(1)~=' '
        tline(12)=tline(10);
        tline(11)=tline(9);
        tline(10)='0';
        tline(9)=tline(8);
        tline(8)=tline(7);
        tline(7)='0';
        b(i,:)=tline;
    else
        tline(1)=[];
        tline(12)=tline(9);
        tline(11)=tline(8);
        tline(10)='0';
        tline(9)=tline(7);
        tline(8)=tline(6);
        tline(7)='0';
        tline(6)='0';
        b(i,:)=tline;
    end
end
V_str=b;