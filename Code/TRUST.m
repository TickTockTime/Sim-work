%% trust function
%{
@:param alpha,beta: ֱ������ֵ�ͼ������ֵ�ĳ�ʼȨ��
@:param Ts, Ta:     ����T�ڽڵ�ɹ������������ܽ�������
@:param Thn:        ֱ�ӽ�������
@:param Tbefore:    �ڵ���ʷ����ֵ
@:return trust:     �ڵ㵱ǰ������ֵ
%}
function [trust] = TRUST(alpha, beta, Ts, Ta, t, Thn, Tbefore)
% ��������ֵ
RW=0.2*Ts/Ta;
% ֱ������ֵ
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