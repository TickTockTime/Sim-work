%% check function
%{
@;param Tnow, Tbefore:  本次周期的信任值，上次周期的信任值
@:param Eta:            对应系数
@:param Err:            异常等级
@:return Tafter:        审计之后的节点信任值
%}
function [Tafter]=CHECK(Tnow, Tbefore, Eta, Err)
    deltaT=Tnow-Tbefore;
    if deltaT<0
        Tafter=Tbefore+Eta(Err)*deltaT;
    else
        Tafter=Tbefore+1/Eta(Err)*deltaT;
    end
    if Tafter<0
        Tafter=0;
    elseif Tafter>1
        Tafter=1;
    end
    
end