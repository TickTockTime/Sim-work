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
% ESlevel=CONTROL(Elayer);
% MSlevel=CONTROL(Mlayer);
% FSlevel=CONTROL(Flayer);
% ��������֮��Ľ����ڵ㣨�ֳ���ڵ�ƽ���֣�
EtoM=[5, 10, 24];
Mreceive=[2, 11];
MtoF=[7, 14];
% ����������
Times = 50;
% �ؼ��ڵ�����ֵ����
Keynode1=zeros(1,Times+1); Keynode1(1,1)=Trust0;
Keynode2=zeros(1,Times+1); Keynode2(1,1)=Trust0;
Keynode3=zeros(1,Times+1); Keynode3(1,1)=Trust0;
Keynode4=zeros(1,Times+1); Keynode4(1,1)=Trust0;


%% Assumption 1����ÿһ������T�У��������ڽڵ������һ�ν���
for t=1:Times
    % ������������������
    ERequest=randi([0,3],N1, N1);
    ESlevel=CONTROL(Elayer);
    [ES, EA]=COUNT(ERequest, ESlevel);
    
    MRequest=randi([0,3],N2, N2);
    MSlevel=CONTROL(Mlayer);
    [MS, MA]=COUNT(MRequest, MSlevel);
    
    
    FSlevel=CONTROL(Flayer);
    
    MsendF=randi([0,3], size(MtoF, 2), N3);
    FRequest=randi([0,3],1,N3);

    
    EsendM=randi([0,3], size(EtoM, 2), size(Mreceive, 2));
    ErevM=randi([0,3], size(Mreceive, 2), size(EtoM, 2));
    for i=1:size(EtoM, 2)
        EA(EtoM(i))=EA(EtoM(i))+sum(EsendM(i,:)>0)+sum(ErevM(:,i)>0);
        ES(EtoM(i))=ES(EtoM(i))+sum(EsendM(i,:)>0)-sum(EsendM(i,:)>ESlevel(EtoM(i)));
        for j=1:size(Mreceive, 2)
            MA(Mreceive(j))=MA(Mreceive(j))+sum(ErevM(j,:)>0)+sum(EsendM(:,j)>0);
            MS(Mreceive(j))=MS(Mreceive(j))+sum(ErevM(j,:)>0)-sum(ErevM(j,:)>ESlevel(Mreceive(j)));
            if ErevM(j, i)<=MSlevel(j) && ErevM(j, i)~=0
                ES(EtoM(i))=ES(EtoM(i))+1;
            end
            if EsendM(i, j)<=ESlevel(i) && EsendM(i, j)~=0
                MS(Mreceive(j))=ES(EtoM(i))+1;
            end
        end
    end

    
    FA=zeros(1, N3);
    FS=zeros(1, N3);
    
    for i=1:N3
        if FRequest(i)>0
            FA(i)=FA(i)+1;
            if FRequest(i)<=FSlevel(i)
                FS(i)=FS(i)+1;
                if i<=N3/2
                    MS(MtoF(1))=MS(MtoF(1))+1;
                elseif i<=N3 && i>N3/2
                    MS(MtoF(2))=MS(MtoF(2))+1;
                end
            end
        end
        FA(i)=FA(i)+sum(MsendF(:,i)>0);
        for j=1:size(MtoF, 2)
            MA(MtoF(j))=MA(MtoF(j))+sum(MsendF(j,:)>0)+sum(FRequest(1, (1+(j-1)*N3/2):(5+(j-1)*N3/2))>0);
            MS(MtoF(j))=MS(MtoF(j))+sum(MsendF(j,:)>0)-sum(MsendF(j,:)>MSlevel(MtoF(j)));
            if MsendF(j, i)<=MSlevel(MtoF(j)) && MsendF(j, i)~=0
                FS(i)=FS(i)+1;
            end
        end
    end
    
    
    for i=1:N1
        Elayer(i)=TRUST(alpha0, beta0, ES(i), EA(i), t, Thn, Elayer(i));
    end

    for i=1:N2
        Mlayer(i)=TRUST(alpha0, beta0, MS(i), MA(i), t, Thn, Mlayer(i));
    end
    
    for i=1:N3
        Flayer(i)=TRUST(alpha0, beta0, N3, N3, t, Thn, Flayer(i));
    end
    
    Keynode1(1, t+1)=Elayer(10);
    Keynode2(1, t+1)=Mlayer(2);
    Keynode3(1, t+1)=Mlayer(7);
    Keynode4(1, t+1)=Flayer(2);
end
temp=0:Times;
subplot(4,1,1);
plot(temp,Keynode1);
subplot(4,1,2);
plot(temp,Keynode2);
subplot(4,1,3);
plot(temp,Keynode3);
subplot(4,1,4);
plot(temp,Keynode4);
