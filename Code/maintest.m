%% parameters init

N1=30; N2=15; N3=10;                                                       %DCS企业层、监控层、现场层网络
M1=2;                                                                      %关键控制指令条数
Trust0=0.5;
alpha0=0.7; beta0=0.3; Thn=5;
P=3; m=3; lamda=0.8;

%% 三个关键节点
% 信任值矩阵
T=[0, Trust0, Trust0;
   0, 0, Trust0;
   0, 0, 0];
T0=T;
% 关键节点的初始信任值
Trust1(1,1)=Trust0; Trust2(1,1)=Trust0; Trust3(1,1)=Trust0;
% 每一个节点的所在的层数
Node_State=[1, 2, 3]; 
% 交互次数
Times=15;
% 异常等级对应的惩罚系数
Eta=[20,30,40];
Err=zeros(1,3);
Err(1,2)=2;



for t=1:Times
    % 计算信任值
    T1 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 1);
    T2 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 2);
    T3 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 3);
    T(1,2)=T1;T(1,3)=T2;T(2,3)=T3;
    % 审计
    Temp=CHECK(T, T0, Eta, Err);
    T=Temp;T0=T;
    % 每个节点的时序
    Trust1(1,t+1)=T(1,2); Trust2(1,t+1)=T(1,3); Trust3(1,t+1)=T(2,3);
end