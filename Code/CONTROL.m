%% multi-level access control Function
function [ServiceLevel]=CONTROL(Trust)

% 已知总体信任度是3个等级 S={拒绝服务，部分服务，正常服务}；P={0.2，0.5，0.8}
P=[0.2,0.5,0.8];
S=[1,2,3,4];
if Trust<=P(1)
    ServiceLevel=S(1);
elseif Trust>P(1) && Trust<=P(2)
    ServiceLevel=S(2);
elseif Trust>P(2) && Trust<=P(3)
    ServiceLevel=S(3);
elseif Trust>P(3)
    ServiceLevel=S(4);
end

end