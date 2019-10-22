%% trust function
%{
@:param alpha,beta: 直接信任值和间接信任值的初始权重
@:param Ts, Ta:     周期T内节点成功交互次数和总交互次数
@:param Thn:        直接交互门限
@:param Tbefore:    节点历史信任值
@:return trust:     节点当前的信任值
%}
function [trust] = TRUST(alpha, beta, Ts, Ta, t, Thn, Tbefore)
% 奖励信任值
RW=0.2*Ts/Ta;
% 直接信任值
U=Ts/Ta;
DT=DTRUST(U,0.6,0.4);
if t<Thn
%     RT=RTRUST(T, State, Pos);
    trust=(alpha/(alpha+beta)*DT+beta/(alpha+beta)*Tbefore)+RW;
elseif t>=Thn
    trust=DT+RW;
end

if trust>1
    trust=1;
end

end