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
%% 仿真部分
% 相邻两层节点之间的交换节点
EtoM=[5, 10, 24];
Mreceive=[2, 11];
MtoF=[7, 14];


Times = 20;

%% 外部渗透
p_out=zeros(1, 10);
for N=10:5:50
    out_attack_s=0;
    N1=0.3*N; N2=0.2*N; N3=0.1*N; 
    EtoM=zeros(1, floor(0.1*N1));
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