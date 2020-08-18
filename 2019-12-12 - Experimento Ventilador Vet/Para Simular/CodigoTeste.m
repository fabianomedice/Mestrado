clc
clear all
close all

%% Leitura dos Dados

Name = 'M10FR002_TOT7.5_Vet.txt';


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

% figure (1)
% plot(Time1,Pressure1,'b')
% hold on
% plot(Time2,Pressure2,'r')
% plot(Time3,Pressure3,'g')
% legend ('Ventilador','Pulmão','Aspirador')
% xlabel('Time [s]')
% ylabel('Pressure [cmH_2O]')
% hold off

% figure (2)
% plot(Time1,Flow1,'b')
% hold on
% plot(Time2,Flow2,'r')
% plot(Time3,Flow3,'g')
% legend ('Ventilador','Pulmão','Aspirador')
% xlabel('Time [s]')
% ylabel('Flow [L/s]')
% hold off

%% Configurando a simulação
%Tempo da Simulação (seg) - Tempo total da simulação no simulink
Tsimulacao = 5+15+20+15+20+15+5;
%Tempo de amostragem (seg) - Tempo para cada calculo do simulink
Tamostra = 0.001;
%Calculo da pressão de aspiração
Pasp = [-15.2979 -23.3827 -039.5964];
%Dados do paciente
E=38.1970;
Rrs=3.3464;
VR=0;

%Simulação 1
%Pressão do Ventilador (cm H20)
Pvent = 5; %Pvent ideal

% % Condições iniciais
%Condição do Integrador
PressaoInicial = Pvent;
VolumeInicial = VR+PressaoInicial/E;
%Condição do Delay
PressaoDelay = Pvent;
Delay = 0.01;
Ptrigger = 0.0;
Limite_Vazao = 0.5;
TOT = 7.5;
Tamanho_Sonda = 10;
PaspMin = Pasp(1,1);
PaspMed = Pasp(1,2);
PaspMax = Pasp(1,3);
sim('NovoModeloControlePorPressaoRev2_Inter')
PalvSim1=PAlvSimulada;
PventSim1=PVentSimulada;
PaspSim1=PAspSimulada;

% % % %Simulação 2
% % % %Pressão do Ventilador (cm H20)
% % % Pvent = 4.6372; %Pvent ventilador
% % % 
% % % % % Condições iniciais
% % % %Condição do Integrador
% % % PressaoInicial = Pvent;
% % % VolumeInicial = VR+PressaoInicial/E;
% % % %Condição do Delay
% % % PressaoDelay = Pvent;
% % % Delay = 0.1;
% % % Ptrigger = 0.5;
% % % TOT = 7.5;
% % % Tamanho_Sonda = 10;
% % % PaspMin = Pasp(1,1);
% % % PaspMed = Pasp(1,2);
% % % PaspMax = Pasp(1,3);
% % % sim('NovoModeloControlePorPressaoRev1')
% % % PalvSim2=PAlvSimulada;
% % % PventSim2=PVentSimulada;
% % % PaspSim2=PAspSimulada;
% % % 
% % % %Simulação 3
% % % %Pressão do Ventilador (cm H20)
% % % Pvent = mean([3.1745 3.0065 2.7525]); %Pvent ventilador
% % % 
% % % % % Condições iniciais
% % % %Condição do Integrador
% % % PressaoInicial = Pvent;
% % % VolumeInicial = VR+PressaoInicial/E;
% % % %Condição do Delay
% % % PressaoDelay = Pvent;
% % % Delay = 0.1;
% % % Ptrigger = 0.5;
% % % TOT = 7.5;
% % % Tamanho_Sonda = 10;
% % % PaspMin = Pasp(1,1);
% % % PaspMed = Pasp(1,2);
% % % PaspMax = Pasp(1,3);
% % % sim('NovoModeloControlePorPressaoRev1')
% % % PalvSim3=PAlvSimulada;
% % % PventSim3=PVentSimulada;
% % % PaspSim3=PAspSimulada;
% % % 
% % % %Simulação 4
% % % %Pressão do Ventilador (cm H20)
% % % Pvent = 4.6372; %Pvent ventilador
% % % PventQueda = [3.1745 3.0065 2.7525]; %Pvent durante aspiração
% % % 
% % % % % Condições iniciais
% % % %Condição do Integrador
% % % PressaoInicial = Pvent;
% % % VolumeInicial = VR+PressaoInicial/E;
% % % %Condição do Delay
% % % PressaoDelay = Pvent;
% % % Delay = 0.1;
% % % Ptrigger = 0.5;
% % % TOT = 7.5;
% % % Tamanho_Sonda = 10;
% % % PaspMin = Pasp(1,1);
% % % PaspMed = Pasp(1,2);
% % % PaspMax = Pasp(1,3);
% % % sim('NovoModeloControlePorPressaoRev1Modificado')
% % % PalvSim4=PAlvSimulada;
% % % PventSim4=PVentSimulada;
% % % PaspSim4=PAspSimulada;


%% Plots
% % figure (3)
% % plot(Time2(1:10920),Pressure2(1:10920),'b')
% % hold on
% % plot(PalvSim1.Time+5,PalvSim1.Data,'r')
% % % plot(PalvSim2.Time+5,PalvSim2.Data,'g')
% % % plot(PalvSim3.Time+5,PalvSim3.Data,'m')
% % % plot(PalvSim4.Time+5,PalvSim4.Data,'k')
% % legend ('Sinal Pulmão','Simulação CPAP 5 cmH_2O','Simulação CPAP 4.6372 cmH_2O','Simulação CPAP média das quedas','Simulação com a queda de CPAP')
% % xlabel('Time [s]')
% % ylabel('Pressure [cmH_2O]')
% % hold off

figure (4)
plot(Time1(1:10920),Pressure1(1:10920),'b')
hold on
plot(PventSim1.Time+5,PventSim1.Data,'b--')
plot(Time2(1:10920),Pressure2(1:10920),'r')
plot(PalvSim1.Time+5,PalvSim1.Data,'r--')
plot(Time3(1:10920),Pressure3(1:10920),'g')
plot(PaspSim1.Time+5,PaspSim1.Data,'g--')
legend ('Sinal Ventilador','Ventilador Simulado','Sinal Pulmão','Pulmão Simulado','Sinal Aspirador','Aspirador Simulado')
xlabel('Time [s]')
ylabel('Pressure [cmH_2O]')
title('Simulando com CPAP 5 cmH_2O')
hold off

% % figure (5)
% % plot(Time1(1:10920),Pressure1(1:10920),'b')
% % hold on
% % plot(PventSim2.Time+5,PventSim2.Data,'b--')
% % plot(Time2(1:10920),Pressure2(1:10920),'r')
% % plot(PalvSim2.Time+5,PalvSim2.Data,'r--')
% % plot(Time3(1:10920),Pressure3(1:10920),'g')
% % plot(PaspSim2.Time+5,PaspSim2.Data,'g--')
% % legend ('Sinal Ventilador','Ventilador Simulado','Sinal Pulmão','Pulmão Simulado','Sinal Aspirador','Aspirador Simulado')
% % xlabel('Time [s]')
% % ylabel('Pressure [cmH_2O]')
% % title('Simulando com CPAP medido pelo sensor (4.6372 cmH_2O)')
% % hold off
% % 
% % figure (6)
% % plot(Time1(1:10920),Pressure1(1:10920),'b')
% % hold on
% % plot(PventSim3.Time+5,PventSim3.Data,'b--')
% % plot(Time2(1:10920),Pressure2(1:10920),'r')
% % plot(PalvSim3.Time+5,PalvSim3.Data,'r--')
% % plot(Time3(1:10920),Pressure3(1:10920),'g')
% % plot(PaspSim3.Time+5,PaspSim3.Data,'g--')
% % legend ('Sinal Ventilador','Ventilador Simulado','Sinal Pulmão','Pulmão Simulado','Sinal Aspirador','Aspirador Simulado')
% % xlabel('Time [s]')
% % ylabel('Pressure [cmH_2O]')
% % title('Simulando com CPAP médio das quedas medida pelo sensor (2.9778 cmH_2O)')
% % hold off
% % 
% % figure (7)
% % plot(Time1(1:10920),Pressure1(1:10920),'b')
% % hold on
% % plot(PventSim4.Time+5,PventSim4.Data,'b--')
% % plot(Time2(1:10920),Pressure2(1:10920),'r')
% % plot(PalvSim4.Time+5,PalvSim4.Data,'r--')
% % plot(Time3(1:10920),Pressure3(1:10920),'g')
% % plot(PaspSim4.Time+5,PaspSim4.Data,'g--')
% % legend ('Sinal Ventilador','Ventilador Simulado','Sinal Pulmão','Pulmão Simulado','Sinal Aspirador','Aspirador Simulado')
% % xlabel('Time [s]')
% % ylabel('Pressure [cmH_2O]')
% % title('Simulando com CPAP medido e as quedas')
% % hold off