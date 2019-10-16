%% optimization function
function [State]=OPT(R_temp,R0)
n=3;
State=zeros(1,n);
lamda=0.8;
R_temp=[3, 4, 6;
    5,7,3;
    9, 5, 1];
R0=10*ones(3,3);
R=R_temp./R0;

for i=1:n
    if max(R(i,:))<lamda
        State(1,i)=1;
    end
end



end