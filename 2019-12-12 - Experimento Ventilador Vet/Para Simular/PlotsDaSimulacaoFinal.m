%% Ventila��o controlada por press�o
%Limpeza da Tela
clc
%Limpeza de Vari�veis
clear all

%% Parametros de Controle constantes

%Tempo da Simula��o (seg)
%Tempo total da simula��o no simulink
Tsimulacao = 60+15+20;
%Tempo de amostragem (seg)
%Tempo para cada calculo do simulink
Tamostra = 0.001;

%Press�o do Ventilador (cm H20)
Pvent = 10; %Pvent ideal

%Press�o do Aspirador (cm H20)
Pasp = -200; %%Fonte: <Compara��o entre os sistemas aberto e fechado de aspira��o. Revis�o sistem�tica> pg4

%Volume residual (L)
VR = 1.200; %Fonte: Guyton

%Vaz�o M�xima (L/s)
Limite_Vazao = 0.5;

%Aspira��o Intermitente
Habilitar = 0; %Desabilitado
Hz = 1; %Valor de Default (Hz)

%% Paciente
%%------------------------------------
%  Mutaveis
%%------------------------------------
%Elast�ncia (cm H2O /L)
E = 1/0.120;
%Resist�ncia das vias aereas (cm H2O / L/s)
Rrs = 5;
%%------------------------------------
%%------------------------------------

%% Condi��es iniciais
%Condi��o do Integrador
PressaoInicial = Pvent;
VolumeInicial = VR+PressaoInicial/E;
%Condi��o do Delay
PressaoDelay = Pvent;

%% ------------------------------------
%  Mutaveis
%%------------------------------------
Delay = 0.050;
Ptrigger = 0.5;
TOT = 7.5;
Tamanho_Sonda = 6;
%%------------------------------------
%%------------------------------------
sim('NovoModeloControlePorPressaoRevFinal_Ideal')

PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
DeltaP = PSemAspiracao-PminAspiracao;

figure (1)
plot(PAlvSimulada.Time,PAlvSimulada.Data,'b')
xlabel('Time [s]')
ylabel('Alveolar Pressure [cmH_2O]')
title({['Crs = ' num2str(1/E*1000) 'mL/cmH2O | Rrs = ' num2str(Rrs) 'cmH2O/L/s | TOT = ' num2str(TOT) ' | Sonda = ' num2str(Tamanho_Sonda)],['Delay = ' num2str(Delay*1000) ' ms | Ptrigger = ' num2str(Ptrigger) 'cmH2O'],['CPAP = ' num2str(PSemAspiracao) 'cmH2O | Pasp m�x = ' num2str(PminAspiracao) 'cmH2O | \DeltaP = ' num2str(DeltaP) 'cmH2O']})

indice=1;
ResultadosVentiladorIdeal = zeros(1,12); 

ResultadosVentiladorIdeal(indice,1)=Rrs;%Resist�ncia
ResultadosVentiladorIdeal(indice,2)=1/E;%Complacencia
ResultadosVentiladorIdeal(indice,3)=Delay;%Delay
ResultadosVentiladorIdeal(indice,4)=Ptrigger;%Ptrigger
ResultadosVentiladorIdeal(indice,5)=TOT;%TOT
ResultadosVentiladorIdeal(indice,6)=Tamanho_Sonda;%Sonda

ResultadosVentiladorIdeal(indice,8)=PSemAspiracao;%CPAP
ResultadosVentiladorIdeal(indice,9)=PminAspiracao;%Pasp min
ResultadosVentiladorIdeal(indice,10)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
ResultadosVentiladorIdeal(indice,11)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
ResultadosVentiladorIdeal(indice,12)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o

%% Aspira��o Intermitente
Habilitar = 1; %Desabilitado
Hz = 1; %Valor de Default (Hz)

sim('NovoModeloControlePorPressaoRevFinal_Ideal')

PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
DeltaP = PSemAspiracao-PminAspiracao;

figure (2)

plot(PAlvSimulada.Time,PAlvSimulada.Data,'b')
xlabel('Time [s]')
ylabel('Alveolar Pressure [cmH_2O]')
title({['Crs = ' num2str(1/E*1000) 'mL/cmH2O | Rrs = ' num2str(Rrs) 'cmH2O/L/s | TOT = ' num2str(TOT) ' | Sonda = ' num2str(Tamanho_Sonda)],['Delay = ' num2str(Delay*1000) ' ms | Ptrigger = ' num2str(Ptrigger) 'cmH2O'],['CPAP = ' num2str(PSemAspiracao) 'cmH2O | Pasp m�x = ' num2str(PminAspiracao) 'cmH2O | \DeltaP = ' num2str(DeltaP) 'cmH2O']})

indice=1;
ResultadosVentiladorIdealIntermitente = zeros(1,12); 

ResultadosVentiladorIdealIntermitente(indice,1)=Rrs;%Resist�ncia
ResultadosVentiladorIdealIntermitente(indice,2)=1/E;%Complacencia
ResultadosVentiladorIdealIntermitente(indice,3)=Delay;%Delay
ResultadosVentiladorIdealIntermitente(indice,4)=Ptrigger;%Ptrigger
ResultadosVentiladorIdealIntermitente(indice,5)=TOT;%TOT
ResultadosVentiladorIdealIntermitente(indice,6)=Tamanho_Sonda;%Sonda
ResultadosVentiladorIdealIntermitente(indice,7)=Hz;%Frequencia de Aspira��o
ResultadosVentiladorIdealIntermitente(indice,8)=PSemAspiracao;%CPAP
ResultadosVentiladorIdealIntermitente(indice,9)=PminAspiracao;%Pasp min
ResultadosVentiladorIdealIntermitente(indice,10)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
ResultadosVentiladorIdealIntermitente(indice,11)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
ResultadosVentiladorIdealIntermitente(indice,12)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o

ResultadosVentiladorIdeal
ResultadosVentiladorIdealIntermitente


