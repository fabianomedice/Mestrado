%% Ventilação controlada por pressão
%Limpeza da Tela
clc
%Limpeza de Variáveis
clear all

%% Parametros de Controle

%Tempo da Simulação (seg)
%Tempo total da simulação no simulink
Tsimulacao = 20+15+20;
%Tempo de amostragem (seg)
%Tempo para cada calculo do simulink
Tamostra = 0.001;

%Pressão do Ventilador (cm H20)
Pvent = 10; %Pvent ideal
% Pvent = 0; %Patm, circuito aberto

%Pressão do Aspirador (cm H20)
Pasp = -200; %%Fonte: <Comparação entre os sistemas aberto e fechado de aspiração. Revisão sistemática> pg4
%Elastância (cm H2O /L)
E = 1/0.020;
%Resistência das vias aereas (cm H2O / L/s)
Rrs = 5;

%Volume residual (L)
VR = 1.200; %Fonte: Guyton
% %PEEP (cm H20)
% %A pressão exercida nos pulmões do paciente pelo ventilador no final da expiração.
% PEEP = 4.5; %Fonte: AVALIAÇÃO DA MECÂNICA RESPIRATÓRIA E DA OXIGENAÇÃO PRÉ E PÓS-ASPIRAÇÃO DE SECREÇÃO EM CRIANÇAS SUBMETIDAS À VENTILAÇÃO PULMONAR MECÂNICA

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
            disp('Tamanho não válido')
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
            disp('Tamanho não válido')
            disp('Tente novamente')
            clear Tamanho_Sonda
            clear TOT
        end
    else
        clc
        disp('Tamanho não válido')
        disp('Tente novamente')
        clear TOT
        clear Tamanho_Sonda
    end
end

if Tamanho_Sonda ~= 0
    Habilitar = input('Habilitar Aspiração intermitente? S ou N? ','s');
    
    if Habilitar == 'S'
        Habilitar = 1;
        disp('Aspiração intermitente habilitada')
        Hz = input('Favor inserir frequência de pulso [Hz] ');
    else
        disp('Aspiração intermitente não habilitada')
        Habilitar = 0;
        Hz = 1;    
    end
else
    Habilitar = 0;
    Hz = 1;  
end

Delay = input('Escolha o tempo para o delay do ventilador [s] ');
% Delay = 0.01;
Ptrigger = input('Escolha a pressão de trigger do ventilador [cmH2O] ');
% Ptrigger = 0.0;
Limite_Vazao = input('Escolha a vazão máxima entregue pelo o ventilador [L/s] ');
% Limite_Vazao = 0.5;

%% Condições iniciais
%Condição do Integrador
PressaoInicial = Pvent;
VolumeInicial = VR+PressaoInicial/E;
%Condição do Delay
PressaoDelay = Pvent;


