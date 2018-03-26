%% 绘制多测道曲线图
function multi_curve(sampling,Point_num,V_Final)
C=rand(40,3);%%曲线颜色矩阵
Vt=zeros(1,length(Point_num));
for i=1:1:sampling
    for j=1:length(Point_num)
        Vt(j)=V_Final(i+40*(j-1));
    end
    semilogy(Point_num,abs(Vt),'color',C(i,:),'LineWidth',1.5)
    hold on
end
xlabel('Points_number');ylabel('Voltage');title('多测道曲线图');
hold off