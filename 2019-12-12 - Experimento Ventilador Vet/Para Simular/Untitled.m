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

% figure (1)
% plot(Time1(1:10920),Pressure1(1:10920),'b')
% hold on
% plot(Time2(1:10920),Pressure2(1:10920),'r')
% plot(Time3(1:10920),Pressure3(1:10920),'g')
% legend ('Ventilador','Pulmão','Aspirador')
% xlabel('Time [s]')
% ylabel('Pressure [cmH_2O]')
% hold off

% % %% Filtros
% % Fc = 1; %frequencia de corte
% % Fa = 100;%frequencia de amostragem
% % [B, A]=butter(2,2*Fc/Fa);
% % Pressure1 = filtfilt(B,A,Pressure1);
% % Flow1 = filtfilt(B,A,Flow1);
% % Pressure2 = filtfilt(B,A,Pressure2);
% % Flow2 = filtfilt(B,A,Flow2);
% % Pressure3 = filtfilt(B,A,Pressure3);
% % Flow3 = filtfilt(B,A,Flow3);


%% Configurando a simulação
%Tempo da Simulação (seg) - Tempo total da simulação no simulink
% Tsimulacao = 5+15+20+15+20+15+5;
Tsimulacao = 5+15+20+15+20+15+5+10; %+10 para alinhar os sinais
%Tempo de amostragem (seg) - Tempo para cada calculo do simulink
Tamostra = 0.001;
%Calculo da pressão de aspiração
% Pasp = [-15.2979 -23.3827 -039.5964]; %Valores medidos
% Pasp = [-230 -270 -310];
% Pasp = [Time3(1:10920) Pressure3(1:10920)];
Pasp = [Time3 Pressure3];

% Pasp = [Time3(1:10920) Pressure3(1:10920)];
% for i=1:length(Pasp)
%     if Pasp(i,2)>0
%         Pasp(i,2) = 0;
%     end
% end
% 
% Ganho = 15;
% Pasp(:,2) = Ganho*Pasp(:,2);

%Dados do paciente
% E=38.1970;
% Rrs=3.3464;

E1=38.1970;
E=E1;
% R1=5;
R1=3.3464;
Rrs=R1;
VR=0;

%Simulação 1
%Pressão do Ventilador (cm H20)
Pvent1 = 5; %Pvent ideal
Pvent = [Time1 Pressure1];

% % Condições iniciais
%Condição do Integrador
% PressaoInicial = Pvent;
PressaoInicial = Pvent(1,2);
VolumeInicial = VR+PressaoInicial/E;
%Condição do Delay
% PressaoDelay = Pvent;
PressaoDelay = 0;
Delay = 0.0;
Ptrigger = 0.0;
Limite_Vazao = 1;
TOT = 7.5;
Tamanho_Sonda = 10;
% PaspMin = Pasp(1,1);
% PaspMed = Pasp(1,2);
% PaspMax = Pasp(1,3);
PaspMin = 1;
PaspMed = 2;
PaspMax = 3;

sim('NovoModeloControlePorPressaoRev1')
PalvSim1=PAlvSimulada;
PventSim1=PVentSimulada;
PaspSim1=PAspSimulada;
VventSim1=VVentSimulada;
VaspSim1=VAspSimulada;

%Simulação 2
E2=38.1970;
E=E2;
R2=5;
Rrs=R2;
% Delay = 0.1;
VolumeInicial = VR+PressaoInicial/E;
% Ganho = 10;
% Pasp(:,2) = Ganho*Pasp(:,2);

% Pasp = [-230 -270 -310];

% PaspMin = Pasp(1,1);
% PaspMed = Pasp(1,2);
% PaspMax = Pasp(1,3);

sim('NovoModeloControlePorPressaoRev1')
PalvSim2=PAlvSimulada;
PventSim2=PVentSimulada;
PaspSim2=PAspSimulada;


%Simulação 3
E3=38.1970;
E=E3;
R3=1;
Rrs=R3;
% Delay = 0.1;
VolumeInicial = VR+PressaoInicial/E;
% Ganho = 10;
% Pasp(:,2) = Ganho*Pasp(:,2);

% Pasp = [-230 -270 -310];

% PaspMin = Pasp(1,1);
% PaspMed = Pasp(1,2);
% PaspMax = Pasp(1,3);

sim('NovoModeloControlePorPressaoRev1')
PalvSim3=PAlvSimulada;
PventSim3=PVentSimulada;
PaspSim3=PAspSimulada;


%% Plots

% % % % % % % figure (1)
% % % % % % % plot(Time1(1:10920),Pressure1(1:10920),'b')
% % % % % % % hold on
% % % % % % % plot(Time2(1:10920),Pressure2(1:10920),'r')
% % % % % % % plot(Time3(1:10920),Pressure3(1:10920),'g')
% % % % % % % legend ('Sinal Ventilador','Sinal Pulmão','Sinal Aspirador','location','southwest')
% % % % % % % xlabel('Time [s]')
% % % % % % % ylabel('Pressure [cmH_2O]')
% % % % % % % title('Dados M10FR002-TOT7.5-Vet - Sonda 10 com TOT 7.5')
% % % % % % % hold off
% % % % % % % 
% % % % % % % figure (2)
% % % % % % % plot(Time1(1:10920),Flow1(1:10920),'b')
% % % % % % % hold on
% % % % % % % plot(Time3(1:10920),Flow3(1:10920),'g')
% % % % % % % legend ('Sinal Ventilador','Sinal Pulmão','Sinal Aspirador','location','southwest')
% % % % % % % xlabel('Time [s]')
% % % % % % % ylabel('Flow [L/s]')
% % % % % % % title('Dados M10FR002-TOT7.5-Vet - Sonda 10 com TOT 7.5')
% % % % % % % hold off

% % % % % % % figure (3)
% % % % % % % plot(Time1(1:10920),Pressure1(1:10920),'b')
% % % % % % % hold on
% % % % % % % % plot(PventSim1.Time+5,PventSim1.Data,'b--')
% % % % % % % plot(PventSim1.Time,PventSim1.Data,'b--') %Utilizando o sinal de aspiração
% % % % % % % plot(Time2(1:10920),Pressure2(1:10920),'r')
% % % % % % % % plot(PalvSim1.Time+5,PalvSim1.Data,'k')
% % % % % % % plot(PalvSim1.Time,PalvSim1.Data,'k') %Utilizando o sinal de aspiração
% % % % % % % plot(Time3(1:10920),Pressure3(1:10920),'g')
% % % % % % % % plot(PaspSim1.Time+5,PaspSim1.Data,'g--')
% % % % % % % plot(PaspSim1.Time,PaspSim1.Data,'g--') %Utilizando o sinal de aspiração
% % % % % % % % legend ('Sinal Ventilador','Ventilador Simulado','Sinal Pulmão','Pulmão Simulado','Sinal Aspirador','Aspirador Simulado','location','southwest')
% % % % % % % xlabel('Time [s]')
% % % % % % % ylabel('Pressure [cmH_2O]')
% % % % % % % % title(['CPAP ', num2str(Pvent),' cmH_2O | GanhoPasp ', num2str(Ganho),' | Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s'])
% % % % % % % % title({['Fig9 - TOT 7.5 com Sonda 10'] ['CPAP ', num2str(Pvent),' cmH_2O | Pasp ', num2str(Pasp(1,1)),'cmH_2O ',num2str(Pasp(1,2)), 'cmH_2O ',num2str(Pasp(1,3)), 'cmH_2O'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s'] ['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s']})
% % % % % % % title({['Fig1 - TOT 7.5 com Sonda 10'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s'] ['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s']})
% % % % % % % % ylim([-50 10])
% % % % % % % hold off

% figure (3)
% plot(Time2(1:10920),Pressure2(1:10920),'r')
% hold on
% plot(PalvSim1.Time,PalvSim1.Data,'k') %Utilizando o sinal de aspiração
% xlabel('Time [s]')
% ylabel('Pressure [cmH_2O]')
% legend ('Sinal Pulmão','Pulmão Simulado','location','southwest')
% title({['Fig5 - TOT 7.5 com Sonda 10'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s'] ['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s']})
% hold off
% 
% 
% figure (4)
% plot(Time1(1:10920),Flow1(1:10920),'b')
% hold on
% % plot(VventSim1.Time+5,VventSim1.Data,'b--')
% plot(VventSim1.Time,VventSim1.Data,'r--') %Utilizando o sinal de aspiração
% plot(Time3(1:10920),Flow3(1:10920),'g')
% % plot(VaspSim1.Time+5,VaspSim1.Data,'g--')
% plot(VaspSim1.Time,VaspSim1.Data,'m--') %Utilizando o sinal de aspiração
% legend ('Sinal Ventilador','Ventilador Simulado','Sinal Aspirador','Aspirador Simulado','location','best')
% xlabel('Time [s]')
% ylabel('Flow [L/s]')
% % title({['Fig10 - TOT 7.5 com Sonda 10'] ['CPAP ', num2str(Pvent),' cmH_2O | Pasp ', num2str(Pasp(1,1)),'cmH_2O ',num2str(Pasp(1,2)), 'cmH_2O ',num2str(Pasp(1,3)), 'cmH_2O'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s'] ['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s']})
% title({['Fig6 - TOT 7.5 com Sonda 10'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s'] ['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s']})
% hold off

% figure (5)
% plot(Time2(1:10920),Pressure2(1:10920),'k')
% hold on
% % plot(PalvSim1.Time+5,PalvSim1.Data,'r--') 
% % plot(PalvSim2.Time+5,PalvSim2.Data,'b--') 
% plot(PalvSim1.Time,PalvSim1.Data,'r--') 
% plot(PalvSim2.Time,PalvSim2.Data,'b--') 
% % plot(PalvSim1.Time,PalvSim1.Data,'r.-') %Utilizando o sinal de aspiração
% % plot(PalvSim2.Time,PalvSim2.Data,'b--') %Utilizando o sinal de aspiração
% legend ('Sinal Pulmão',['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s'],['Ers ', num2str(E2), 'cmH_2O/L | Rrs ',num2str(R2), 'cmH_2O/L/s'],'location','southwest')
% xlabel('Time [s]')
% ylabel('Pressure [cmH_2O]')
% hold off
% title({['Fig10 - TOT 7.5 com Sonda 10'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s']})

figure (5)
plot(Time2(1:10920),Pressure2(1:10920),'k')
hold on
plot(PalvSim1.Time,PalvSim1.Data,'r--') 
plot(PalvSim2.Time,PalvSim2.Data,'b--') 
plot(PalvSim3.Time,PalvSim3.Data,'g--') 
legend ('Sinal Pulmão',['Ers ', num2str(E1), 'cmH_2O/L | Rrs ',num2str(R1), 'cmH_2O/L/s'],['Ers ', num2str(E2), 'cmH_2O/L | Rrs ',num2str(R2), 'cmH_2O/L/s'],['Ers ', num2str(E3), 'cmH_2O/L | Rrs ',num2str(R3), 'cmH_2O/L/s'],'location','southwest')
xlabel('Time [s]')
ylabel('Pressure [cmH_2O]')
hold off
title({['Fig8 - TOT 7.5 com Sonda 10'] [' Delay ', num2str(Delay), 's | Ptrigger ',num2str(Ptrigger), 'cmH_2O | LimVazao ', num2str(Limite_Vazao),'L/s']})
