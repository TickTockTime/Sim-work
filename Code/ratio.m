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
Eta=[20 30 40];
trust_Thn=[0.7 0.4 0.2];
%% 仿真部分（在每一个周期T中，假设相邻节点均进行一次交互）
%% 攻击者部分
% 攻击对象
Target=[2];
% 不同的攻击目的（获取控制权限、窃取数据、篡改关键指令、DDOS、误操作）
Attack=[1 2 3 4 5];

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
    Elayer(i).id=i;
    Elayer(i).trust=Trust0;
    Elayer(i).trustB=Trust0;
    if ismember(i, EtoM)
        Elayer(i).NerNode=N1+size(Mreceive, 2);
    else
        Elayer(i).NerNode=N1;
    end
    Elayer(i).Req=zeros(1, Elayer(i).NerNode);
    Elayer(i).Rev=zeros(1, Elayer(i).NerNode);
    Elayer(i).Ns=zeros(1, Elayer(i).NerNode);
    Elayer(i).Na=zeros(1, Elayer(i).NerNode);
    Elayer(i).Nsa=zeros(1, Elayer(i).NerNode);
    Elayer(i).Nsc=zeros(1, Elayer(i).NerNode);
    Elayer(i).T=Elayer(i).trust*ones(1, Elayer(i).NerNode);
    Elayer(i).Slevel=CONTROL(Elayer(i).trust);
    Elayer(i).Err=0;
    Elayer(i).EHistory=0;
    Elayer(i).Cap=zeros(1, m);
end

for i=1:N2
    Mlayer(i).id=i;
    Mlayer(i).trust=Trust0;
    Mlayer(i).trustB=Trust0;
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
    Mlayer(i).Nsa=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).Nsc=zeros(1, Mlayer(i).NerNode);
    Mlayer(i).T=Mlayer(i).trust*ones(1, Mlayer(i).NerNode);
    Mlayer(i).Slevel=CONTROL(Mlayer(i).trust);
    Mlayer(i).Err=0;
    Mlayer(i).EHistory=0;
    Mlayer(i).Cap=zeros(1, m);
end

for i=1:N3
    Flayer(i).id=i;
    Flayer(i).trust=Trust0;
    Flayer(i).trustB=Trust0;
    Flayer(i).NerNode=1;
    Flayer(i).Req=zeros(1, Flayer(i).NerNode);
    Flayer(i).Rev=zeros(1, Flayer(i).NerNode);
    Flayer(i).Ns=zeros(1, Flayer(i).NerNode);
    Flayer(i).Na=zeros(1, Flayer(i).NerNode);
    Flayer(i).Nsa=zeros(1, Flayer(i).NerNode);
    Flayer(i).Nsc=zeros(1, Flayer(i).NerNode);
    Flayer(i).T=Flayer(i).trust*ones(1, Flayer(i).NerNode);
    Flayer(i).Slevel=CONTROL(Flayer(i).trust);
    Flayer(i).Err=0;
    Flayer(i).EHistory=0;
    Flayer(i).Cap=zeros(1, m);
end

Times = 20;

%% 外部渗透
p_out=zeros(1, 10);
for i=1:10
    out_attack_s=0;
    for t=1:Times
        state=zeros(1, 3);
        node=floor(i*N1/10);
%         node=15;
        node2=randi([0 3]);
        node1=node-node2;
        Eattack=RAND(node1, N1);
        Mattack=RAND(node2, N2);
        state(1, 1)=ISERR(Eattack, EtoM);
        state(1, 2)=ISERR(Mattack, Mreceive);
        state(1, 3)=ISERR(Mattack, MtoF);
        if ismember(1, state)
            out_attack_s=out_attack_s+1;
        end
    end
    p_out(i) = (Times-out_attack_s)/Times;
end




%% 内部渗透
p_inside=zeros(1, 10);
for i=1:10
    inside_attack_s=0;
    for t=1:Times
        state=zeros(1, 3);
        node=floor(i*N2/10);
        Mattack=RAND(node, N2);
        state(1, 2)=ISERR(Mattack, Mreceive);
        state(1, 3)=ISERR(Mattack, MtoF);
        if ismember(1, state)
            inside_attack_s=inside_attack_s+1;
        end
    end
    p_inside(i) = (Times-inside_attack_s)/Times;
end


%% plot distgraph
subplot(2,1,1)
x=0.1:0.1:1;
bar(x, p_out);
xlabel("恶意节点比例");
ylabel("免疫成功率");
title("外部攻击不同恶意节点比例阻断效果");
subplot(2,1,2)
x=0.1:0.1:1;
bar(x, p_inside);
xlabel("恶意节点比例");
ylabel("免疫成功率");
title("内部攻击不同恶意节点比例阻断效果");