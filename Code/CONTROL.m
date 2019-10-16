%% multi-level access control Function
function [ServiceLevel]=CONTROL(Trust)

% ��֪�������ζ���3���ȼ� S={�ܾ����񣬲��ַ�����������}��P={0.2��0.5��0.8}
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