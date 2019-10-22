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
% 每一层网络节点的信任值
Elayer=Trust0*ones(1, N1);
Mlayer=Trust0*ones(1, N2);
Flayer=Trust0*ones(1, N3);
% 每一层网络节点的服务等级
ESlevel=CONTROL(Elayer);
MSlevel=CONTROL(Mlayer);
FSlevel=CONTROL(Flayer);
% 相邻两层之间的交互节点（现场层节点平均分）
EtoM=[5, 10, 12, 24];
Mreceive=[2, 11];
MtoF=[7, 14];
% 仿真周期数
Times = 20;
% 关键节点信任值序列
T=zeros(1,Times+1); T(1,1)=Trust0;
% Assumption 1：在每一个周期T中，假设相邻节点均进行一次交互
for t=1:Times
    % 随机产生服务请求矩阵
    ERequest=randi([0,3],N1, N1);
    ESlevel=CONTROL(Elayer);
    [ES, EA]=COUNT(ERequest, ESlevel);
    for i=1:N1
        Elayer(i)=TRUST(alpha0, beta0, ES(i), EA(i), t, Thn, Elayer(i));
    end
    MRequest=randi([0,3],N2, N2);
    MSlevel=CONTROL(Mlayer);
    [MS, MA]=COUNT(MRequest, MSlevel);
    for i=1:N2
        Mlayer(i)=TRUST(alpha0, beta0, MS(i), MA(i), t, Thn, Mlayer(i));
    end
    for i=1:N3
        Flayer(i)=TRUST(alpha0, beta0, N3, N3, t, Thn, Flayer(i));
    end
    FSlevel=CONTROL(Flayer);
    T(1, t+1)=Elayer(1);
end
temp=0:Times;
plot(temp,T);



% for t=1:Times
%     % 计算信任值
%     T1 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 1);
%     T2 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 2);
%     T3 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 3);
%     T(1,2)=T1;T(1,3)=T2;T(2,3)=T3;
%     % 审计
%     Temp=CHECK(T, T0, Eta, Err);
%     T=Temp;T0=T;
%     % 每个节点的时序
%     Trust1(1,t+1)=T(1,2); Trust2(1,t+1)=T(1,3); Trust3(1,t+1)=T(2,3);
% end