%% check function
%{
@;param Tnow, Tbefore:  �������ڵ�����ֵ���ϴ����ڵ�����ֵ
@:param Eta:            ��Ӧϵ��
@:param Err:            �쳣�ȼ�
@:return Tafter:        ���֮��Ľڵ�����ֵ
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