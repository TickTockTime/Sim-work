clear all;
clc;
%% 更秀利大
N1=30; N2=15; N3=10; 
EtoM=[5, 10, 24];
Mreceive=[2, 11];
MtoF=[7, 14];
s = zeros(1,N1*(N1-1)+N2*(N2-1)+N3);
t = zeros(1,N1*(N1-1)+N2*(N2-1)+N3);
for i=1:N1
    s(1,1+(i-1)*(N1-1):(N1-1)*i)=i;
end
for i=1:N2
    s(1,N1*(N1-1)+1+(i-1)*(N2-1):N1*(N1-1)+(N2-1)*i)=N1+i;
end
for i=1:N3
    s(1, N1*(N1-1)+N2*(N2-1)+i)=N1+N2+i;
end
for i=1:size(EtoM, 2)
    s=[s EtoM(i)*ones(1,size(Mreceive, 2))];
end
for i=1:size(Mreceive, 2)
    s=[s (N1+Mreceive(i))*ones(1,size(EtoM, 2))];
end
for i=1:size(MtoF, 2)
    s=[s (N1+MtoF(i))*ones(1, N3/2)];
end

for i=1:N1
    temp=1:N1;
    temp(temp==i)=[];
    t(1,1+(i-1)*(N1-1):(N1-1)*i)=temp;
end
for i=1:N2
    temp=N1+1:N1+N2;
    temp(temp==N1+i)=[];
    t(1,N1*(N1-1)+1+(i-1)*(N2-1):N1*(N1-1)+(N2-1)*i)=temp;
end

for i=1:N3
    if i<=N3/2
        t(1, N1*(N1-1)+N2*(N2-1)+i)=N1+MtoF(1);
    else
        t(1, N1*(N1-1)+N2*(N2-1)+i)=N1+MtoF(2);
    end
end

for i=1:size(EtoM, 2)
    t=[t N1+Mreceive];
end

for i=1:size(Mreceive, 2)
    t=[t EtoM];
end

t=[t N1+N2+1:N1+N2+N3];

%% Plot network
figure(1);
G = digraph(s,t);
plot(G);
title("DCS 利大");
saveas(gcf,"../Fig/DCS利大.png");

figure(2);
subplot(1,2,1);
Elayer=1:N1;
H = subgraph(G,Elayer);
plot(H);
title("二匍蚊利大");

subplot(1,2,2);
Mlayer=N1+1:N1+N2;
H = subgraph(G,Mlayer);
plot(H);
title("酌陣蚊利大");
saveas(gcf, "../Fig/DSC利大蕉何.png");

% P = shortestpath(G,7,52);