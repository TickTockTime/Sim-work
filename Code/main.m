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

%% ���沿�֣���ÿһ������T�У��������ڽڵ������һ�ν�����
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



% ����������
Times = 1;
% �ؼ��ڵ�����ֵ����
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


