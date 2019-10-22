%% multi-level access control Function
%{
@param Trust:   ����ֵ
@return SLevel: ����ȼ�
%}
function [SLevel]=CONTROL(Trust)
%{
��֪�������ζ���3���ȼ� 
S={�ܾ����񣬲��ַ��񣬴󲿷ַ��� ��������}��
P={0.2��0.5��0.8}
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