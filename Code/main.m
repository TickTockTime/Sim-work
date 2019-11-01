clear all;
clc;
%% parameters init
%{
@:param N1,N2,N3:   DCS企业层、监控层、现场层网络大小
@:param M1:         关键控制指令条数
@:param Trust0:     每个节点初始信任值
@:param alpha,beta: 直接信任值和间接信任值的初始权重
@:param Thn:        直接交互门限
@:param P:          访问控制等级数
@:param m:          能力衡量数目
@:param lamda:      调整系数（相同）
%}
N1=30; N2=15; N3=10; 
alpha0=0.7; beta0=0.3; 
Trust0=0.5; M1=2; Thn=5; P=3; m=3; lamda=0.8;

%% 仿真部分（在每一个周期T中，假设相邻节点均进行一次交互）
% 相邻两层节点之间的交换节点
EtoM=[5, 10, 24];
Mreceive=[2, 11];
MtoF=[7, 14];
% 初始化网络节点的数据
%{
node struct：
    trust:  信任值
    Ns:     两个节点交互的成功次数
    Na:     两个节点总交互次数
    Nsc:    两个节点连续成功交互次数
    
%}
for i=1:N1
    Elayer(i).trust=Trust0;
    Elayer(i).id=i;
    if ismember(i, EtoM)
        Elayer(i).NerNode=N1+size(Mreceive, 2);
    else
        Elayer(i).NerNode=N1;
    end
    Elayer(i).Req=zeros(1, Elayer(i).NerNode);
    Elayer(i).Rev=zeros(1, Elayer(i).NerNode);
    Elayer(i).Ns=zeros(1, Elayer(i).NerNode);
    Elayer(i).Na=zeros(1, Elayer(i).NerNode);
    Elayer(i).Nsc=zeros(1, Elayer(i).NerNode);
    Elayer(i).T=Elayer(i).trust*ones(1, Elayer(i).NerNode);
    Elayer(i).Slevel=CONTROL(Elayer(i).trust);
end

for i=1:N2
    Mlayer(i).trust=Trust0;
    Mlayer(i).id=i;
    if ismember(i, Mreceive)
        Mlayer(i).NerNode=N2+size(EtoM, 2);
    elseif ismember(i, MtoF)
        Mlayer(i).NerNode=N2+N3/2;
    else
        Mlayer(i).NerNode=N2;
    end
    Mlayer(i).Req=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).Rev=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).Ns=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).Na=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).Nsc=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).T=Mlayer(i).trust*ones(1, Mlayer(i).NerNode);
    Mlayer(i).Slevel=CONTROL(Mlayer(i).trust);
end

for i=1:N3
    Flayer(i).trust=Trust0;
    Flayer(i).id=i;
    Flayer(i).NerNode=1;
    Flayer(i).Req=zeros(1, Flayer(i).NerNode);
    Flayer(i).Rev=zeros(1, Flayer(i).NerNode);
    Flayer(i).Ns=zeros(1, Flayer(i).NerNode);
    Flayer(i).Na=zeros(1, Flayer(i).NerNode);
    Flayer(i).Nsc=zeros(1, Flayer(i).NerNode);
    Flayer(i).T=Flayer(i).trust*ones(1, Flayer(i).NerNode);
    Flayer(i).Slevel=CONTROL(Flayer(i).trust);
end


% 仿真周期数
Times = 200;
% 关键节点信任值序列
Keynode1=zeros(1,Times+1); Keynode1(1,1)=Trust0;
Keynode2=zeros(1,Times+1); Keynode2(1,1)=Trust0;
Keynode3=zeros(1,Times+1); Keynode3(1,1)=Trust0;
Keynode4=zeros(1,Times+1); Keynode4(1,1)=Trust0;

for t=1:Times
    for i=1:N1
        Elayer(i).Slevel=CONTROL(Elayer(i).trust);
%         Elayer(i).Req=ones(1,Elayer(i).NerNode);
        Elayer(i).Req=randi([0,3],1,Elayer(i).NerNode);
        [Elayer(i).Na, Elayer(i).Ns, Elayer(i).Nsc]=COUNT(Elayer(i).Req, Elayer(i).Slevel, Elayer(i).id, Elayer(i).Na,Elayer(i).Ns, Elayer(i).Nsc);
        Elayer(i).T=TRUST(alpha0,beta0,Elayer(i).Ns,Elayer(i).Na,Elayer(i).Nsc,Thn,(sum(Elayer(i).T(1,1:N1))-Elayer(i).T(i))/(N1-1),Elayer(i).id);
        Elayer(i).trust=(sum(Elayer(i).T)-Elayer(i).T(i))/(Elayer(i).NerNode-1);
    end
    
    
    for i=1:N2
        Mlayer(i).Slevel=CONTROL(Mlayer(i).trust);
%         Mlayer(i).Req=ones(1,Mlayer(i).NerNode);
        Mlayer(i).Req=randi([0,3],1,Mlayer(i).NerNode);
        [Mlayer(i).Na, Mlayer(i).Ns, Mlayer(i).Nsc]=COUNT(Mlayer(i).Req, Mlayer(i).Slevel, Mlayer(i).id, Mlayer(i).Na,Mlayer(i).Ns, Mlayer(i).Nsc);
        Mlayer(i).T=TRUST(alpha0,beta0,Mlayer(i).Ns,Mlayer(i).Na,Mlayer(i).Nsc,Thn,(sum(Mlayer(i).T(1,1:N2))-Mlayer(i).T(i))/(N2-1),Mlayer(i).id);
        Mlayer(i).trust=(sum(Mlayer(i).T)-Mlayer(i).T(i))/(Mlayer(i).NerNode-1);
    end
    
    for i=1:N3
        Flayer(i).Slevel=CONTROL(Flayer(i).trust);
%         Mlayer(i).Req=ones(1,Mlayer(i).NerNode);
        Flayer(i).Req=randi([0,3],1,Flayer(i).NerNode);
        [Flayer(i).Na, Flayer(i).Ns, Flayer(i).Nsc]=COUNT(Flayer(i).Req, Flayer(i).Slevel, Flayer(i).id, Flayer(i).Na,Flayer(i).Ns, Flayer(i).Nsc);
        Flayer(i).T=TRUST(alpha0,beta0,Flayer(i).Ns,Flayer(i).Na,Flayer(i).Nsc,Thn,Flayer(i).trust,Flayer(i).id);
        Flayer(i).trust=Flayer(i).T;
    end
    
    Keynode1(1, t+1)=Elayer(2).trust;
    Keynode2(1, t+1)=Elayer(3).trust;
    Keynode3(1, t+1)=Mlayer(4).trust;
    Keynode4(1, t+1)=Flayer(2).trust;
end
temp=0:Times;
subplot(4,1,1);
plot(temp,Keynode1,'linewidth',1.5);
subplot(4,1,2);
plot(temp,Keynode2,'linewidth',1.5);
subplot(4,1,3);
plot(temp,Keynode3,'linewidth',1.5);
subplot(4,1,4);
plot(temp,Keynode4,'linewidth',1.5);