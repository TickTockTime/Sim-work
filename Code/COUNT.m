%% function to count successful times of each node
%{
@:param ERequest:   �����������
@:param ESlevel:    �ڵ���������ȼ�
@:return ES:        �ڵ�ɹ���������
@:return EA:        �ڵ㽻������
%}
function [A, S, SC]=COUNT(Req, Slevel, node, A, S, SC)

num=size(Req,2);
for i=1:num
    if i~=node && Req(1, i)~=0
        A(1,i)=A(1,i)+1;
        if  Req(1,i)<=Slevel
            S(1, i)=S(1,i)+1;
            SC(1,i)=SC(1,i)+1;
        else
%             S(1, i)=0;
            SC(1,i)=0;
        end
    end
end


end