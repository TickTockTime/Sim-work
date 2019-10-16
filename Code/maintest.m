%% parameters init

N1=30; N2=15; N3=10;                                                       %DCS��ҵ�㡢��ز㡢�ֳ�������
M1=2;                                                                      %�ؼ�����ָ������
Trust0=0.5;
alpha0=0.7; beta0=0.3; Thn=5;
P=3; m=3; lamda=0.8;

%% �����ؼ��ڵ�
% ����ֵ����
T=[0, Trust0, Trust0;
   0, 0, Trust0;
   0, 0, 0];
T0=T;
% �ؼ��ڵ�ĳ�ʼ����ֵ
Trust1(1,1)=Trust0; Trust2(1,1)=Trust0; Trust3(1,1)=Trust0;
% ÿһ���ڵ�����ڵĲ���
Node_State=[1, 2, 3]; 
% ��������
Times=15;
% �쳣�ȼ���Ӧ�ĳͷ�ϵ��
Eta=[20,30,40];
Err=zeros(1,3);
Err(1,2)=2;



for t=1:Times
    % ��������ֵ
    T1 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 1);
    T2 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 2);
    T3 = TRUST(alpha0, beta0, t, t,Thn, T, Node_State, 3);
    T(1,2)=T1;T(1,3)=T2;T(2,3)=T3;
    % ���
    Temp=CHECK(T, T0, Eta, Err);
    T=Temp;T0=T;
    % ÿ���ڵ��ʱ��
    Trust1(1,t+1)=T(1,2); Trust2(1,t+1)=T(1,3); Trust3(1,t+1)=T(2,3);
end