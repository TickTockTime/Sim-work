%% multi-level access control Function
%{
@param Trust:   信任值
@return SLevel: 服务等级
%}
function [SLevel]=CONTROL(Trust)
%{
已知总体信任度是3个等级 
S={拒绝服务，部分服务，大部分服务， 正常服务}；
P={0.2，0.5，0.8}
%}
P=[0.2,0.5,0.8];
S=[0,1,2,3];
num=size(Trust, 2);
SLevel=zeros(1,num);
for i=1:num
    if Trust(i)<=P(1)
        SLevel(i)=S(1);
    elseif Trust(i)>P(1) && Trust(i)<=P(2)
        SLevel(i)=S(2);
    elseif Trust(i)>P(2) && Trust(i)<=P(3)
        SLevel(i)=S(3);
    elseif Trust(i)>P(3)
        SLevel(i)=S(4);
    end
end

end