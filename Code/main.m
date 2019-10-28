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
    if ismember(i, EtoM)
        Elayer(i).NerNode=N1+size(Mreceive, 2);
    else
        Elayer(i).NerNode=N1;
    end
    Elayer(i).Req=zeros(1, Elayer(i).NerNode);
    Elayer(i).Ns=zeros(1, Elayer(i).NerNode);
    Elayer(i).Na=zeros(1, Elayer(i).NerNode);
    Elayer(i).Nsc=zeros(1, Elayer(i).NerNode);
    Elayer(i).Slevel=CONTROL(Elayer(i).trust);
end



% 仿真周期数
Times = 1;
% 关键节点信任值序列
Keynode1=zeros(1,Times+1); Keynode1(1,1)=Trust0;
Keynode2=zeros(1,Times+1); Keynode2(1,1)=Trust0;
Keynode3=zeros(1,Times+1); Keynode3(1,1)=Trust0;
Keynode4=zeros(1,Times+1); Keynode4(1,1)=Trust0;

for t=1:Times
    for i=1:N1
        Elayer(i).Req=randi([0,3],1,Elayer(i).NerNode);
        [Elayer(i).Ns, Elayer(i).Na]=COUNT(Elayer(i).Req, Elayer(i).Slevel);
    end
end


