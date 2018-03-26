%% This function is mainly used to smooth the data of the same time window
%% in the adjacent measurement points 
%% T as time window data
%% V as TEM voltage data
%% C0 as soomthing coefficient,the higher the C0,the higher the degree of
%% smoothness
function V_Final=Point_smooth(T,V,C0)
C1=C0/100;
r1=zeros(length(T)-1,1);
r2=zeros(length(T)-1,1);
for j=2:length(V)-1
    r1(j)=1/(log(T(j))-log(T(j-1)))^2;
    r2(j)=1/(log(T(j+1))-log(T(j)))^2;
    V(j)=(1-C1)*V(j)+C1*(r1(j)^2/(r1(j)^2+r2(j))^2*(V(j-1))+r1(j)^2/(r1(j)^2+r2(j)^2)*(V(j+1)));
end
V_Final=V;