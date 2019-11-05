%% trust function
%{
@:param alpha,beta: 直接信任值和间接信任值的初始权重
@:param Ts, Ta:     周期T内节点成功交互次数和总交互次数
@:param Thn:        直接交互门限
@:param Tbefore:    节点历史信任值
@:return trust:     节点当前的信任值
%}
function [trust] = TRUST(alpha, beta, Ts, Ta, t, Thn, Tbefore, node)
n=size(Ts, 2);
trust=zeros(1, n);

for i=1:n
    if i~=node
        if Ta(i)==0
            RW=0;
            U=0;
        else
            RW=0.2*Ts(i)/Ta(i);
            U=Ts(i)/Ta(i);
        end
        DT=DTRUST(U,0.6,0.4);
        if t(i)<Thn
            trust(i)=(alpha/(alpha+beta)*DT+beta/(alpha+beta)*Tbefore)+RW;
        elseif t(i)>=Thn
            trust(i)=DT+RW;
        end
        
        if trust(i)>1
            trust(i)=1;
        elseif trust(i)<0
            trust(i)=0;
        end
    end
end

end