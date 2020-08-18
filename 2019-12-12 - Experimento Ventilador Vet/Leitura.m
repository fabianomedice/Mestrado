function [P_Completo, Tpulmao, Ppulmao, IndexCorte, PmedAsp, PmedVent, PmedPulmao,VmedVent,Pventilador,Paspirador] = Leitura(Name)
%Entrega os sinais do tempo e pressao do pulmão de cada aspiração, o index
%de corte de cada um, a pressão média de aspiração, ventilação e pulmonar utilizada 
%e vazão do ventilador enquanto não há aspiração

%VmedVent, Pventilador e Paspirador foi inserido para fazer a resistência da traqueia do ventilador

% clc
% clear all
% close all

%Leitura dos Dados

% Name = 'E06FR002_TOT7.5_Vet.txt';


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

% figure (1)
% plot(Time1,Pressure1,'b')
% hold on
% plot(Time2,Pressure2,'r')
% plot(Time3,Pressure3,'g')
% legend ('Ventilador','Pulmão','Aspirador')
% xlabel('Time')
% ylabel('Pressure')
% hold off

% figure (2)
% plot(Time1,Flow1,'b')
% hold on
% plot(Time2,Flow2,'r')
% plot(Time3,Flow3,'g')
% legend ('Ventilador','Pulmão','Aspirador')
% xlabel('Time')
% ylabel('Flow')
% hold off

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

%% Filtros
Fc = 1; %frequencia de corte
Fa = 100;%frequencia de amostragem
[B, A]=butter(2,2*Fc/Fa);
Pressure1 = filtfilt(B,A,Pressure1);
Flow1 = filtfilt(B,A,Flow1);
Pressure2 = filtfilt(B,A,Pressure2);
Flow2 = filtfilt(B,A,Flow2);
Pressure3 = filtfilt(B,A,Pressure3);
Flow3 = filtfilt(B,A,Flow3);


%% ------------------------------------
% Criando o time series
%%-------------------------------------

Ventilation = timetable(seconds(Time1),Pressure1,Flow1,'VariableNames',{'Pressure','Flow'});
% Ventilador = timeseries([Pressure1,Flow1],Time1,['Pressure','Flow'])
Lung = timetable(seconds(Time2),Pressure2,Flow2,'VariableNames',{'Pressure','Flow'});
Suction = timetable(seconds(Time3),Pressure3,Flow3,'VariableNames',{'Pressure','Flow'});

%synchronize %sincroniza os dados
Data = synchronize(Ventilation,Lung,Suction,'union','previous');
Data.Flow_Lung = zeros(length(Data.Flow_Lung),1); %Não havia como medir a vazao pelo o sensor e passar a sonda

P_Completo = Data.Pressure_Lung;

%Criando vetor de vazão para o pulmão
%Considerando que não há vazamentos, a vazão do pulmão é igual ao tanto de vazão que vem do ventilador mais a que é retirada pela a sucção
% % % % % % % % Data.Flow_Lung = Data.Flow_Ventilation + Data.Flow_Suction;

% % figure (1)
% % plot (Data.Time,Data.Pressure_Ventilation,'b',Data.Time,Data.Pressure_Lung,'r',Data.Time,Data.Pressure_Suction,'g')
% % legend('Ventilation','Lung','Suction','Location','Best')
% % xlabel('Time')
% % ylabel('Pressure [cmH2O]')
% % 
% % hold on
% % MP=mean(Data.Pressure_Suction)*ones(length(Data.Pressure_Suction),1);
% % plot(Data.Time,MP*0.9)
% % hold off

% % figure (2)
% % plot (Data.Time,Data.Flow_Ventilation,'b',Data.Time,Data.Flow_Lung,'r',Data.Time,Data.Flow_Suction,'g')
% % legend('Ventilation','Lung','Suction','Location','Best')
% % xlabel('Time')
% % ylabel('Flow [L/s]')

%% ------------------------------------
% Achando os intervalos
%%-------------------------------------
%Conferindo em todos os sinais

Indice_Inicio = zeros(9,1);
Indice_Fim = zeros(9,1);
Limiar = 0;
Indice = 1;

for i=1:length(Data.Pressure_Suction)
    if Data.Pressure_Suction(i) < 0.9*mean(Data.Pressure_Suction) && Limiar == 0
        %Procurando o primeiro ponto que passa pelo Limiar de 0.9*Média crescente
        Limiar = 1; %Agora não passa outro ponto
        Indice_Inicio(Indice) = i; %Salva o indice
    elseif Data.Pressure_Suction(i) > 0.9*mean(Data.Pressure_Suction) && Limiar == 1
        %Procurando o primeiro ponto que passa pelo Limiar de 0.9*Média decrescente
        Limiar = 0; %Agora não passa outro ponto
        Indice_Fim(Indice) = i; %Salva o indice
        Indice = Indice+1; %Prepara para o outro intervalo
    end
end

% ------------------------
% Debugger
% ------------------------

%Corte do sinal de sinal com erro
if Name == 'E06FR001_TOT8.5_Vet.txt'
    %O 7 intervalo não foi uma aspiração completa então deve ser retirado
    Indice_Inicio(7) = [];
    Indice_Fim(7) = [];
elseif Name == 'M10FR002_TOT8.5_Vet.txt'
    %O 7 intervalo não foi uma aspiração completa então deve ser retirado
    Indice_Inicio(7) = [];
    Indice_Fim(7) = [];
elseif Name == 'M10FR003_TOT8.5_Vet.txt'
    %O 4 intervalo não foi uma aspiração completa então deve ser retirado
    Indice_Inicio(4) = [];
    Indice_Fim(4) = [];
elseif Name == 'E12FR001_TOT8.5_Vet.txt'
    %O 1 intervalo passou do limiar na ativação do sensor (erro de leitura)
    Indice_Inicio(1) = [];
    Indice_Fim(1) = [];
elseif Name == 'M12FR001_TOT8.5_Vet.txt'
    %O 1 intervalo passou do limiar na ativação do sensor (erro de leitura)
    Indice_Inicio(1) = [];
    Indice_Fim(1) = [];
elseif Name == 'M12FR003_TOT8.5_Vet.txt'
    %O 1 intervalo passou do limiar na ativação do sensor (erro de leitura)
    Indice_Inicio(1) = [];
    Indice_Fim(1) = [];
end

% --------------------------

% figure (1)
% plot (Data.Time,Data.Pressure_Ventilation,'b',Data.Time,Data.Pressure_Lung,'r',Data.Time,Data.Pressure_Suction,'g')
% legend('Ventilation','Lung','Suction','Location','Best')
% xlabel('Time')
% ylabel('Pressure [cmH2O]')
% 
% hold on
% MP=mean(Data.Pressure_Suction)*ones(length(Data.Pressure_Suction),1);
% plot(Data.Time,MP*0.9)
% plot(Data.Time(Indice_Inicio),Data.Pressure_Suction(Indice_Inicio),'*',Data.Time(Indice_Fim),Data.Pressure_Suction(Indice_Fim),'*')
% hold off

%% ------------------------------------
% Achando as pressões médias de cada intervalo
%%-------------------------------------
%Tirando a média das pressões dentro de cada intervalo

Medias_Intervalo_Succao = zeros(9,1);
Medias_Intervalo_Ventilacao = zeros(9,1);
Medias_Intervalo_Pulmao = zeros(9,1);
% Maximo_Intervalo_Succao = zeros(6,1);

for i=1:9
    Medias_Intervalo_Succao(i) = mean(Data.Pressure_Suction(Indice_Inicio(i):Indice_Fim(i)));%Media dos intervalos
    Medias_Intervalo_Ventilacao(i) = mean(Data.Pressure_Ventilation(Indice_Inicio(i):Indice_Fim(i)));%Media dos intervalos
    Medias_Intervalo_Pulmao(i) = mean(Data.Pressure_Lung(Indice_Inicio(i):Indice_Fim(i)));%Media dos intervalos
%     Maximo_Intervalo_Succao(i) = min(Data.Pressure_Suction(Indice_Inicio(i):Indice_Fim(i)));%Pressão maxima negativa de cada intervalo
end

%Calculando as pressões por intervalo para os valores finais, acima da média
%Isto foi feito para pegar bem o patamar superior de cada curva
PmedAsp = zeros(9,1);
PmedVent = zeros(9,1);
PmedPulmao = zeros(9,1);
for i=1:9
    Somatorio_Succao = 0;
    Quantidade_Succao = 0;
    Somatorio_Ventilacao = 0;
    Somatorio_VazaoVentilacao = 0;%VmedVent foi inserido para fazer a resistência da traqueia do ventilador
    Quantidade_Ventilacao = 0;
    Somatorio_Pulmao = 0;
    Quantidade_Pulmao = 0;
    for j=Indice_Inicio(i):Indice_Fim(i)
        if Data.Pressure_Suction(j)<Medias_Intervalo_Succao(i)
            Somatorio_Succao = Somatorio_Succao+Data.Pressure_Suction(j);
            Quantidade_Succao = Quantidade_Succao+1;
        end
        if Data.Pressure_Ventilation(j)<Medias_Intervalo_Ventilacao(i)
            Somatorio_Ventilacao = Somatorio_Ventilacao+Data.Pressure_Ventilation(j);
            Somatorio_VazaoVentilacao = Somatorio_VazaoVentilacao+Data.Flow_Ventilation(j);%VmedVent foi inserido para fazer a resistência da traqueia do ventilador
            Quantidade_Ventilacao = Quantidade_Ventilacao+1;
        end
        if Data.Pressure_Lung(j)<Medias_Intervalo_Pulmao(i)
            Somatorio_Pulmao = Somatorio_Pulmao+Data.Pressure_Lung(j);
            Quantidade_Pulmao = Quantidade_Pulmao+1;
        end
    end
    PmedAsp(i) = Somatorio_Succao/Quantidade_Succao;
    PmedVent(i) = Somatorio_Ventilacao/Quantidade_Ventilacao;
    VmedVent(i) = Somatorio_VazaoVentilacao/Quantidade_Ventilacao;%VmedVent foi inserido para fazer a resistência da traqueia do ventilador
    PmedPulmao(i) = Somatorio_Pulmao/Quantidade_Pulmao;
    
end

%% ------------------------------------
% Achando os sinais de pressão alveolar de cada intervalo
%%-------------------------------------
%Achando os valores de inicio de cada intervalo. Valor do tempo da média -5 seg
Tempo_Inicio = zeros(9,1);
Tempo_Fim = zeros(9,1);

i=1;
j=1;
%Procura todos os 9 intervalos iniciais
while j<10
    if Data.Time(i)>=Data.Time(Indice_Inicio(j))-seconds(5)
        %Procura o primeiro timestamp 5 segundos menor q o ponto de encontro de intervalo
        Tempo_Inicio(j)=i; %Salva o indice
        j=j+1; %procura o próximo
    end
    i = i+1;
end
j=1;
i=1;
%Procura todos os 9 intervalos finais
while j<10
    if Data.Time(i)>=Data.Time(Indice_Fim(j))+seconds(5)
        %Procura o primeiro timestamp 5 segundos maior q o ponto de encontro de intervalo
        Tempo_Fim(j)=i; %Salva o indice
        j=j+1; %procura o próximo
    end
    i = i+1;
end

IndexCorte = Tempo_Fim-Tempo_Inicio+1;

%Criando a matriz de sinais do pulmão de cada intervalo
Tpulmao = seconds(zeros(9,max(Tempo_Fim-Tempo_Inicio)+1));
Ppulmao = zeros(9,max(Tempo_Fim-Tempo_Inicio)+1);
Pventilador = zeros(9,max(Tempo_Fim-Tempo_Inicio)+1);

for i=1:9
    Tpulmao(i,1:Tempo_Fim(i)-Tempo_Inicio(i)+1)=Data.Time(Tempo_Inicio(i):Tempo_Fim(i));
    Ppulmao(i,1:Tempo_Fim(i)-Tempo_Inicio(i)+1)=Data.Pressure_Lung(Tempo_Inicio(i):Tempo_Fim(i));
    Pventilador(i,1:Tempo_Fim(i)-Tempo_Inicio(i)+1)=Data.Pressure_Ventilation(Tempo_Inicio(i):Tempo_Fim(i));%Inserido para fazer a resistência da traqueia do ventilador
    Paspirador(i,1:Tempo_Fim(i)-Tempo_Inicio(i)+1)=Data.Pressure_Suction(Tempo_Inicio(i):Tempo_Fim(i));%Inserido para fazer a resistência da traqueia do ventilador
end

end
