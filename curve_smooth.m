%% 曲线圆滑处理
function V_smooth=curve_smooth(T,V)
%% 强干扰剔除
for i=2:length(V)-1
    if abs(V(i-1)/V(i))>10
        V(i)=(abs(V(i-1))+abs(V(i+1)))/2;
    end
end
%% 对第i点进行三点滤波
VF=zeros(length(V),1);
VF(1)=V(1);
for i=2:length(V)-1
    VF(i)=(abs(V(i-1))+2*abs(V(i))+abs(V(i+1)))/4;
end
VF(length(V))=V(length(V));
%% 计算曲线各点的斜率
K=zeros(length(V)-1);
for i=2:length(V)
    K(i-1)=(VF(i)-VF(i-1))/(T(i)-T(i-1));
end
%% 三点指数逼近平滑滤波
for i=2:length(V)-1
    if abs(VF(i))>abs(VF(i-1))%强干扰判定条件
        alfa=atan(K(i-1));
        K(i)=tan(alfa/2);
        delta=abs(K(i)*(T(i-1)-T(i)));
        VF(i)=VF(i-1)-delta;
    elseif abs(VF(i))<abs(VF(i+1))
        alfa=atan(K(i-1));
        K(i)=tan(alfa/2);
        delta=abs(tan(alfa/2)*(T(i-1)-T(i)));
        VF(i)=VF(i-1)-delta;
    end
end
VF(length(V))=VF(length(V)-1);
%% 测道圆滑
VF(length(VF)+1)=VF(length(VF));T(length(T)+1)=T(length(T));
C0=20;
C1=C0/100;%可调常系数，C0越大，圆滑程度越高
r1=zeros(length(T)-1,1);
r2=zeros(length(T)-1,1);
for j=2:length(VF)-1
    r1(j)=1/(log(T(j))-log(T(j-1)))^2;
    r2(j)=1/(log(T(j+1))-log(T(j)))^2;
    VF(j)=(1-C1)*VF(j)+C1*(r1(j)/(r1(j)+r2(j))*(VF(j-1))+r1(j)/(r1(j)+r2(j))*(VF(j+1)));
end
VF(length(VF))=[];
V_smooth=VF;