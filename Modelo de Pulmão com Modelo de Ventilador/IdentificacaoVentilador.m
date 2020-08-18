%% Codigo Rafael

% % % %Sistema verdadeiro
% % % wn = exp(1);
% % % H = tf(wn,[1 wn wn^2]);
% % % 
% % % %Resposta do sistema verdadeiro para uma entrada
% % % fs = 0.05;
% % % U = [zeros(1,10) ones(1,150)];
% % % t = (0:(length(U)-1))*fs;
% % % Y = lsim(H,U,t);
% % % close all
% % % plot(Y)
% % % 
% % % %Identificação do Sistema
% % % Ys = gradient(Y,fs); %gradient usa 3 pontos ao inves das diferenças de 2 pontos
% % % Ys2 = gradient(Ys,fs); %é mais robusta pra estimar derivada
% % % %calculando os minimos quadrados
% % % coeff = [-1*Ys2(:) -1*Ys(:) U(:)]\Y(:);
% % % %fazendo a função estimada
% % % H2 = tf(coeff(3),[coeff(1) coeff(2) 1]);
% % % hold on
% % % Y2 = lsim(H2,U,t);
% % % plot(Y2)
% % % % [Y,T,U] = step(H);

%% Meu codigo

clc
clear all
close all

%Leitura dos Dados

Name = 'PEEPs.txt';


if Name(end-3:end)=='.lvm'
    Dados = lvm_import(Name,2);
    
    Channel_1 = Dados.Segment1.data(:,2);
    Channel_2 = Dados.Segment1.data(:,3);
    Channel_3 = Dados.Segment1.data(:,4);
    Channel_4 = Dados.Segment1.data(:,5);
    Channel_5 = Dados.Segment1.data(:,6);
    Channel_6 = Dados.Segment1.data(:,7);
    Channel_7 = Dados.Segment1.data(:,8);
    Channel_8 = Dados.Segment1.data(:,9);
    Channel_9 = Dados.Segment1.data(:,10);
    
    Time1 = Channel_1;
    Time2 = Channel_4;
    Time3 = Channel_7;
    Pressure1 = 5*Channel_3;
    Pressure2 = Channel_6;
    Pressure3 = Channel_9;
    Flow1 = Channel_2;
    Flow2 = Channel_5;
    Flow3 = Channel_8;
    
elseif Name(end-3:end)=='.csv'
    Dados = readtable('Test.csv');

elseif Name(end-3:end)=='.txt'
    %%comma2point_demo
    comma2point_overwrite(Name)
    Dados = dlmread(Name);
    
    Time1 = Dados(:,1);
    Time2 = Dados(:,4);
    Time3 = Dados(:,7);
    Pressure1 = 5*Dados(:,3);
    Pressure2 = Dados(:,6);
    Pressure3 = Dados(:,9);
    Flow1 = Dados(:,2);
    Flow2 = Dados(:,5);
    Flow3 = Dados(:,8);
end

%% ------------------------------------
% Conserto de BUG
%%-------------------------------------
%Por iniciarem as gravações dos dados em tempos diferentes, há varios vetores com zero em todas as variaveis

indice1 = zeros(length(Dados),1);
indice2 = zeros(length(Dados),1);
indice3 = zeros(length(Dados),1);

for k=1:1:length(Dados)
    if (Time1(k)==0 && Pressure1(k)==0 && Flow1(k)==0) 
        indice1(k,1)=k;
    end
    if (Time2(k)==0 && Pressure2(k)==0 && Flow2(k)==0) 
        indice2(k,1)=k;
    end
    if (Time3(k)==0 && Pressure3(k)==0 && Flow3(k)==0) 
        indice3(k,1)=k;
    end
end

%Retira os zeros do indice
tf = indice1(:)==0;
indice1(tf,:) = [];
tf = indice2(:)==0;
indice2(tf,:) = [];
tf = indice3(:)==0;
indice3(tf,:) = [];

if (indice1 > 0)    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice1)
        Pressure1([indice1(k)-k+1])=[]; %Remove o dado
        Flow1([indice1(k)-k+1])=[]; %Remove o dado
        Time1([indice1(k)-k+1])=[]; %Remove o dado
    end
end
if (indice2 > 0)    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice2)
        Pressure2([indice2(k)-k+1])=[]; %Remove o dado
        Flow2([indice2(k)-k+1])=[]; %Remove o dado
        Time2([indice2(k)-k+1])=[]; %Remove o dado
    end
end
if (indice3 > 0)    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice3)
        Pressure3([indice3(k)-k+1])=[]; %Remove o dado
        Flow3([indice3(k)-k+1])=[]; %Remove o dado
        Time3([indice3(k)-k+1])=[]; %Remove o dado
    end
end

clear tf

%% Filtros
% % Fc = 1; %frequencia de corte
% % Fa = 100;%frequencia de amostragem
% % [B, A]=butter(2,2*Fc/Fa);
% % Pressure1 = filtfilt(B,A,Pressure1);
% % Flow1 = filtfilt(B,A,Flow1);
% % Pressure2 = filtfilt(B,A,Pressure2);
% % Flow2 = filtfilt(B,A,Flow2);
% % Pressure3 = filtfilt(B,A,Pressure3);
% % Flow3 = filtfilt(B,A,Flow3);


%% Plot
figure (1)
plot(Time1,Pressure1,'b')
hold on
% plot(Time2,Pressure2,'r')
% plot(Time3,Pressure3,'g')
legend ('Ventilador','Pulmão','Aspirador')
xlabel('Time [s]')
ylabel('Pressure [cmH_2O]')
hold off

% % figure (2)
% % plot(Time1,Flow1,'b')
% % hold on
% % plot(Time2,Flow2,'r')
% % plot(Time3,Flow3,'g')
% % legend ('Ventilador','Pulmão','Aspirador')
% % xlabel('Time')
% % ylabel('Flow')
% % hold off

%% Identificação do Sistema
Y = Pressure1;
fs = 1/100;
Ys = gradient(Y,fs); %gradient usa 3 pontos ao inves das diferenças de 2 pontos
Ys2 = gradient(Ys,fs); %é mais robusta pra estimar derivada
Ys3 = gradient(Ys2,fs);
%Criando a entrada degrau
U = zeros(size(Y));
% % % % %Sinal quando da uma leve caida da pressão por conta do filtro
% % % % U(2175:10129)=5;
% % % % U(10130:18114)=10;
% % % % U(18115:20903)=15;
% % % % U(20904:23810)=5;
% % % % U(23811:26446)=15;
% % % % U(26447:29286)=10;
% % % % U(29287:31366)=5;
% % % % U(31367:33064)=0;
% % % % U(33065:36341)=15;
% % % % U(36342:37842)=0;
% % % % U(37843:42274)=10;
% % % % U(42275:end)=0;
%Sinal quando há o crescimento da pressão
U(2233:10223)=5;
U(10224:18473)=10;
U(18474:21302)=15;
U(21303:23921)=5;
U(23922:26748)=15;
U(26749:29336)=10;
U(29337:31470)=5;
U(31471:33187)=0;
U(33188:36668)=15;
U(36669:38030)=0;
U(38031:42581)=10;
U(42582:end)=0;
%calculando os minimos quadrados
coeff2 = [-1*Ys2(:) -1*Ys(:) U(:)]\Y(:); %FT 2 ordem
% % % coeff3 = [-1*Ys3(:) -1*Ys2(:) -1*Ys(:) U(:)]\Y(:); %FT 3 ordem
%fazendo a função estimada
H2 = tf(coeff2(3),[coeff2(1) coeff2(2) 1]);%FT 2 ordem
% % % H3 = tf(coeff3(4),[coeff3(1) coeff3(2) coeff3(3) 1]);%FT 3 ordem
% hold on
t = (0:(length(U)-1))*fs;
Y2 = lsim(H2,U,t); %FT 2 ordem

% Hident = tf([-0.2664 0.6455],[1 1.49 0.712]); %Função do Degrau com filtro
Hident = tf([1.035 5.514],[1 2.498 6.164]); %Função do Degrau sem filtro
Yident = lsim(Hident,U,t);
% % % Y3 = lsim(H3,U,t); %FT 3 ordem

figure
plot(t,Y,'b')
hold on
plot(t,Y2,'r')
plot(t,Yident,'g')
% % % plot(Y3,'g')
hold off
legend ('Sinal Adquirido','Sistema Identificado por MMQ','Sistema Identificado pela ferramente "ident"')
% legend ('Sinal Adquirido','Sistema 2 Ordem Identificado','Sistema 3 Ordem Identificado')
xlabel('Time [s]')
ylabel('Pressure [cmH_2O]')

%% Sinal de teste
%Leitura dos Dados

Name = 'testeSubida.txt';


if Name(end-3:end)=='.lvm'
    Dados = lvm_import(Name,2);
    
    Channel_1 = Dados.Segment1.data(:,2);
    Channel_2 = Dados.Segment1.data(:,3);
    Channel_3 = Dados.Segment1.data(:,4);
    Channel_4 = Dados.Segment1.data(:,5);
    Channel_5 = Dados.Segment1.data(:,6);
    Channel_6 = Dados.Segment1.data(:,7);
    Channel_7 = Dados.Segment1.data(:,8);
    Channel_8 = Dados.Segment1.data(:,9);
    Channel_9 = Dados.Segment1.data(:,10);
    
    Time1 = Channel_1;
    Time2 = Channel_4;
    Time3 = Channel_7;
    Pressure1 = 5*Channel_3;
    Pressure2 = Channel_6;
    Pressure3 = Channel_9;
    Flow1 = Channel_2;
    Flow2 = Channel_5;
    Flow3 = Channel_8;
    
elseif Name(end-3:end)=='.csv'
    Dados = readtable('Test.csv');

elseif Name(end-3:end)=='.txt'
    %%comma2point_demo
    comma2point_overwrite(Name)
    Dados = dlmread(Name);
    
    Time1 = Dados(:,1);
    Time2 = Dados(:,4);
    Time3 = Dados(:,7);
    Pressure1 = 5*Dados(:,3);
    Pressure2 = Dados(:,6);
    Pressure3 = Dados(:,9);
    Flow1 = Dados(:,2);
    Flow2 = Dados(:,5);
    Flow3 = Dados(:,8);
end

%% ------------------------------------
% Conserto de BUG
%%-------------------------------------
%Por iniciarem as gravações dos dados em tempos diferentes, há varios vetores com zero em todas as variaveis

indice1 = zeros(length(Dados),1);
indice2 = zeros(length(Dados),1);
indice3 = zeros(length(Dados),1);

for k=1:1:length(Dados)
    if (Time1(k)==0 && Pressure1(k)==0 && Flow1(k)==0) 
        indice1(k,1)=k;
    end
    if (Time2(k)==0 && Pressure2(k)==0 && Flow2(k)==0) 
        indice2(k,1)=k;
    end
    if (Time3(k)==0 && Pressure3(k)==0 && Flow3(k)==0) 
        indice3(k,1)=k;
    end
end

%Retira os zeros do indice
tf1 = indice1(:)==0;
indice1(tf1,:) = [];
tf1 = indice2(:)==0;
indice2(tf1,:) = [];
tf1 = indice3(:)==0;
indice3(tf1,:) = [];

if (indice1 > 0)    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice1)
        Pressure1([indice1(k)-k+1])=[]; %Remove o dado
        Flow1([indice1(k)-k+1])=[]; %Remove o dado
        Time1([indice1(k)-k+1])=[]; %Remove o dado
    end
end
if (indice2 > 0)    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice2)
        Pressure2([indice2(k)-k+1])=[]; %Remove o dado
        Flow2([indice2(k)-k+1])=[]; %Remove o dado
        Time2([indice2(k)-k+1])=[]; %Remove o dado
    end
end
if (indice3 > 0)    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice3)
        Pressure3([indice3(k)-k+1])=[]; %Remove o dado
        Flow3([indice3(k)-k+1])=[]; %Remove o dado
        Time3([indice3(k)-k+1])=[]; %Remove o dado
    end
end

Yteste = Pressure1;
Uteste = zeros(size(Yteste));
Uteste(1132:end) = 5;
tteste = (0:(length(Uteste)-1))*fs;
YtesteY2 = lsim(H2,Uteste,tteste); %FT 2 ordem
YtesteYident = lsim(Hident,Uteste,tteste);

figure
plot(tteste,Yteste,'b')
hold on
plot(tteste,YtesteY2,'r')
plot(tteste,YtesteYident,'g')
hold off
legend ('Sinal Adquirido','Sistema Identificado por MMQ','Sistema Identificado pela ferramente "ident"')
xlabel('Time [s]')
ylabel('Pressure [cmH_2O]')