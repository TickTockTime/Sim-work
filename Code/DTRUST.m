%% direct trust function
function [DT] = DTRUST(U, a1, b1)
N=5;
x=[0.7, 0.6, 0.5, 0.1, 0.9];
t=[0.2, 0.2, 0.3, 0.5, 0.2];
a=[0.5, 0.3, 0.3, 0.2, 0.3];

V_T=zeros(1,N);
for i=1:N
    V_T(i)=MEMBERSHIP(x(i), t(i), a(i));
end

S=max(V_T);
DT=a1*U+b1*S;

end