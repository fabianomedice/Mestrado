%% Ventila��o controlada por press�o
%Limpeza da Tela
clc
%Limpeza de Vari�veis
clear all

%% Parametros de Controle

%Tempo da Simula��o (seg)
%Tempo total da simula��o no simulink
Tsimulacao = 20+15+20;
%Tempo de amostragem (seg)
%Tempo para cada calculo do simulink
Tamostra = 0.001;

%Press�o do Ventilador (cm H20)
Pvent = 10; %Pvent ideal
% Pvent = 0; %Patm, circuito aberto

%Press�o do Aspirador (cm H20)
Pasp = -200; %%Fonte: <Compara��o entre os sistemas aberto e fechado de aspira��o. Revis�o sistem�tica> pg4
%Elast�ncia (cm H2O /L)
E = 1/0.020;
%Resist�ncia das vias aereas (cm H2O / L/s)
Rrs = 5;

%Volume residual (L)
VR = 1.200; %Fonte: Guyton
% %PEEP (cm H20)
% %A press�o exercida nos pulm�es do paciente pelo ventilador no final da expira��o.
% PEEP = 4.5; %Fonte: AVALIA��O DA MEC�NICA RESPIRAT�RIA E DA OXIGENA��O PR� E P�S-ASPIRA��O DE SECRE��O EM CRIAN�AS SUBMETIDAS � VENTILA��O PULMONAR MEC�NICA

i = 0;
while i == 0
    TOT = input('Qual o tamanho do Tubo Orotraquial utilizado [mm]? 7.5 ou 8.5? ');
    if TOT == 7.5
        Tamanho_Sonda = input('Qual o tamanho da sonda utilizada [FR]? 00, 06, 08 ou 10? ');
        if Tamanho_Sonda == 0
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 06
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 08
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 10
            i=1; %Saida do loop
        else
            clc            
            disp('Tamanho n�o v�lido')
            disp('Tente novamente')
            clear Tamanho_Sonda
            clear TOT
        end
    elseif TOT == 8.5
        Tamanho_Sonda = input('Qual o tamanho da sonda utilizada [FR]? 00, 06, 08, 10, ou 12? ');
        if Tamanho_Sonda == 0
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 06
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 08
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 10
            i=1; %Saida do loop
        elseif Tamanho_Sonda == 12
            i=1; %Saida do loop
        else
            clc
            disp('Tamanho n�o v�lido')
            disp('Tente novamente')
            clear Tamanho_Sonda
            clear TOT
        end
    else
        clc
        disp('Tamanho n�o v�lido')
        disp('Tente novamente')
        clear TOT
        clear Tamanho_Sonda
    end
end

if Tamanho_Sonda ~= 0
    Habilitar = input('Habilitar Aspira��o intermitente? S ou N? ','s');
    
    if Habilitar == 'S'
        Habilitar = 1;
        disp('Aspira��o intermitente habilitada')
        Hz = input('Favor inserir frequ�ncia de pulso [Hz] ');
    else
        disp('Aspira��o intermitente n�o habilitada')
        Habilitar = 0;
        Hz = 1;    
    end
else
    Habilitar = 0;
    Hz = 1;  
end

Delay = input('Escolha o tempo para o delay do ventilador [s] ');
% Delay = 0.01;
Ptrigger = input('Escolha a press�o de trigger do ventilador [cmH2O] ');
% Ptrigger = 0.0;
Limite_Vazao = input('Escolha a vaz�o m�xima entregue pelo o ventilador [L/s] ');
% Limite_Vazao = 0.5;

%% Condi��es iniciais
%Condi��o do Integrador
PressaoInicial = Pvent;
VolumeInicial = VR+PressaoInicial/E;
%Condi��o do Delay
PressaoDelay = Pvent;


