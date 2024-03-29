%% check function
%{
@;param Tnow, Tbefore:  本次周期的信任值，上次周期的信任值
@:param Eta:            对应系数
@:param Err:            异常等级
@:return Tafter:        审计之后的节点信任值
%}
function [Tafter]=CHECK(Tnow, Tbefore, Eta, Err)
[n, len]=size(Err);
Tafter=Tnow;
for i=1:len
    if Err(i)~=0
        for node=1:len
            if node~=i
                delt_trust=Tnow(min(node,i), max(node,i))-Tbefore(min(node,i), max(node,i));
                if delt_trust<0
                    Tafter(min(node,i), max(node,i))=Tnow(min(node,i), max(node,i))+Eta(Err(i))*delt_trust;
                else
                    Tafter(min(node,i), max(node,i))=Tnow(min(node,i), max(node,i))+1/Eta(Err(i))*delt_trust;
                end
            end
        end
    end
end

end