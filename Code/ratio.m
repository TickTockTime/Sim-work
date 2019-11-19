clear all;
clc;
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
Eta=[20 30 40];
trust_Thn=[0.7 0.4 0.2];
%% ���沿�֣���ÿһ������T�У��������ڽڵ������һ�ν�����
%% �����߲���
% ��������
Target=[2];
% ��ͬ�Ĺ���Ŀ�ģ���ȡ����Ȩ�ޡ���ȡ���ݡ��۸Ĺؼ�ָ�DDOS���������
Attack=[1 2 3 4 5];

% ��������ڵ�֮��Ľ����ڵ�
EtoM=[5, 10, 24];
Mreceive=[2, 11];
MtoF=[7, 14];
% ��ʼ������ڵ������
%{
node struct��
    trust:  ����ֵ
    Ns:     �����ڵ㽻���ĳɹ�����
    Na:     �����ڵ��ܽ�������
    Nsc:    �����ڵ������ɹ���������
    
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

%% �ⲿ��͸
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




%% �ڲ���͸
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
xlabel("����ڵ����");
ylabel("���߳ɹ���");
title("�ⲿ������ͬ����ڵ�������Ч��");
subplot(2,1,2)
x=0.1:0.1:1;
bar(x, p_inside);
xlabel("����ڵ����");
ylabel("���߳ɹ���");
title("�ڲ�������ͬ����ڵ�������Ч��");