%% ����Բ������
function V_smooth=curve_smooth(T,V)
%% ǿ�����޳�
for i=2:length(V)-1
    if abs(V(i-1)/V(i))>10
        V(i)=(abs(V(i-1))+abs(V(i+1)))/2;
    end
end
%% �Ե�i����������˲�
VF=zeros(length(V),1);
VF(1)=V(1);
for i=2:length(V)-1
    VF(i)=(abs(V(i-1))+2*abs(V(i))+abs(V(i+1)))/4;
end
VF(length(V))=V(length(V));
%% �������߸����б��
K=zeros(length(V)-1);
for i=2:length(V)
    K(i-1)=(VF(i)-VF(i-1))/(T(i)-T(i-1));
end
%% ����ָ���ƽ�ƽ���˲�
for i=2:length(V)-1
    if abs(VF(i))>abs(VF(i-1))%ǿ�����ж�����
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
%% ���Բ��
VF(length(VF)+1)=VF(length(VF));T(length(T)+1)=T(length(T));
C0=20;
C1=C0/100;%�ɵ���ϵ����C0Խ��Բ���̶�Խ��
r1=zeros(length(T)-1,1);
r2=zeros(length(T)-1,1);
for j=2:length(VF)-1
    r1(j)=1/(log(T(j))-log(T(j-1)))^2;
    r2(j)=1/(log(T(j+1))-log(T(j)))^2;
    VF(j)=(1-C1)*VF(j)+C1*(r1(j)/(r1(j)+r2(j))*(VF(j-1))+r1(j)/(r1(j)+r2(j))*(VF(j+1)));
end
VF(length(VF))=[];
V_smooth=VF;