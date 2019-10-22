%% function to count successful times of each node
%{
@:param ERequest:   �����������
@:param ESlevel:    �ڵ���������ȼ�
@:return ES:        �ڵ�ɹ���������
@:return EA:        �ڵ㽻������
%}
function [S, A]=COUNT(ERequest, ESlevel)
%% 0-test data
% ERequest=randi([0,3],5, 5);
% for j=1:5
%     ERequest(j,j)=0;
% end
% ESlevel=randi([0,3],1,5);

%% 1-function part
num=size(ESlevel,2);
Success=zeros(num, num);
for i=1:num
    for j=1:num
        if i~=j && ERequest(i,j)<=ESlevel(1,i) && ERequest(i,j)~=0
            Success(i,j)=1;
        end
    end
end

A=zeros(1, num);
S=zeros(1, num);

for i=1:num
    A(i)=A(i)+sum(ERequest(i,:)>0)+sum(ERequest(:,i)>0);
    S(i)=S(i)+sum(Success(i,:)==1)+sum(Success(:,i)==1);
end

end