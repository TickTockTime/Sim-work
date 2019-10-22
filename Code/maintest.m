%% parameters init
%{
@:param N1,N2,N3:   DCS��ҵ�㡢��ز㡢�ֳ��������С
@:param M1:         �ؼ�����ָ������
@:param Trust0:     ÿ���ڵ��ʼ����ֵ
@:param alpha,beta: ֱ������ֵ�ͼ������ֵ�ĳ�ʼȨ��
@:param Thn:        ֱ�ӽ�������
@:param P:          ���ʿ��Ƶȼ���
@:param m:          ����������Ŀ
@:param lamda:      ����ϵ������ͬ��
%}
N1=30; N2=15; N3=10; 
alpha0=0.7; beta0=0.3; 
Trust0=0.5; M1=2; Thn=5; P=3; m=3; lamda=0.8;

%% ���沿�֣���ÿһ������T�У��������ڽڵ������һ�ν�����
% ÿһ������ڵ������ֵ
Elayer=Trust0*ones(1, N1);
Mlayer=Trust0*ones(1, N2);
Flayer=Trust0*ones(1, N3);
% ÿһ������ڵ�ķ���ȼ�
ESlevel=CONTROL(Elayer);
MSlevel=CONTROL(Mlayer);
FSlevel=CONTROL(Flayer);
% ��������֮��Ľ����ڵ㣨�ֳ���ڵ�ƽ���֣�
EtoM=[5, 10, 12, 24];
Mreceive=[2, 11];
MtoF=[7, 14];
% ����������
Times = 20;
% �ؼ��ڵ�����ֵ����
T=zeros(1,Times+1); T(1,1)=Trust0;
% Assumption 1����ÿһ������T�У��������ڽڵ������һ�ν���
for t=1:Times
    % ������������������
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
%     % ��������ֵ
%     T1 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 1);
%     T2 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 2);
%     T3 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 3);
%     T(1,2)=T1;T(1,3)=T2;T(2,3)=T3;
%     % ���
%     Temp=CHECK(T, T0, Eta, Err);
%     T=Temp;T0=T;
%     % ÿ���ڵ��ʱ��
%     Trust1(1,t+1)=T(1,2); Trust2(1,t+1)=T(1,3); Trust3(1,t+1)=T(2,3);
% end