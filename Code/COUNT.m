%% function to count successful times of each node
%{
@:param ERequest:   �����������
@:param ESlevel:    �ڵ���������ȼ�
@:return ES:        �ڵ�ɹ���������
@:return EA:        �ڵ㽻������
%}
function [A, S, SA, SC]=COUNT(Req, Slevel, node, A, SA, SC)

num=size(Req,2);
S=zeros(1, num);
for i=1:num
    if i~=node && Req(1, i)~=0
        A(1,i)=A(1,i)+1;
        if  Req(1,i)<=Slevel
            S(1, i)=1;
            SA(1, i)=SA(1, i)+1;
            SC(1,i)=SC(1,i)+1;
        else
            S(1, i)=0;
            SC(1,i)=0;
        end
    end
end


end