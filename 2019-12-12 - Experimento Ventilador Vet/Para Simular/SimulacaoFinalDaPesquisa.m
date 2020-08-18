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

%% Cria��o das Matrizes de Resultado
%112 linhas = 4 Pacientes x 4 Configura��es x 7 TOT e Sondas
%1� coluna = n�mero de 1 a 4 de configura�aode E e Rrs (Variavel Paciente)
%2� coluna = n�mero de 1 a 4 de configura��o de Delay e Ptrigger (Variavel Configuracao)
%3� coluna = N�mero de 1 a 7 de combina�ao de TOT e Sonda para plot (Variavel TOTeSonda)
%4� a 9� colunas = Classifica��o - Rrs / Crs / Delay / PTrigger / TOT / Sonda
%10� coluna = Palv sem aspira��o (CPAP)
%11� coluna = Palv min na aspira��o
%12� coluna = DeltaP max = Palv sem aspira��o - Palv min na aspira��o
%13� coluna = M�dia da Palv durante a aspira��o
%14� coluna = min (Vaz�o Asp) = Maior vaz�o de aspira��o
%15� coluna = M�dia da vaz�o durante a aspira��o
ResultadosVentiladorIdeal = zeros(112,15); 
ResultadosVentiladorInterrupcao = zeros(112,15); 

%% Parametros mutaveis por simula��o
indice = 1;
for Paciente = 1:1:4
    if Paciente == 1
        %% Paciente 1 - Paciente com Doen�a Restritiva
        %Elast�ncia (cm H2O /L)
        E = 1/0.020;
        %Resist�ncia das vias aereas (cm H2O / L/s)
        Rrs = 5;
                      
        %% Condi��es iniciais
        %Condi��o do Integrador
        PressaoInicial = Pvent;
        VolumeInicial = VR+PressaoInicial/E;
        %Condi��o do Delay
        PressaoDelay = Pvent;
        
        %% Simula��o
        for Configuracao = 1:1:4
            if Configuracao == 1
                Delay = 0.050;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 2
                Delay = 0.050;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 3
                Delay = 0.100;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 4
                Delay = 0.100;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                                
            end
        end
        
    elseif Paciente == 2
        %% Paciente 2 - Paciente Saud�vel
        %Elast�ncia (cm H2O /L)
        E = 1/0.120;
        %Resist�ncia das vias aereas (cm H2O / L/s)
        Rrs = 5;
        
        %% Condi��es iniciais
        %Condi��o do Integrador
        PressaoInicial = Pvent;
        VolumeInicial = VR+PressaoInicial/E;
        %Condi��o do Delay
        PressaoDelay = Pvent;
        
        %% Simula��o
        for Configuracao = 1:1:4
            if Configuracao == 1
                Delay = 0.050;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 2
                Delay = 0.050;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 3
                Delay = 0.100;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 4
                Delay = 0.100;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                                
            end
        end
        
    elseif Paciente == 3
        %% Paciente 3 - Paciente com Doen�a Restritiva e Obstrutiva
        %Elast�ncia (cm H2O /L)
        E = 1/0.020;
        %Resist�ncia das vias aereas (cm H2O / L/s)
        Rrs = 25;
        
        %% Condi��es iniciais
        %Condi��o do Integrador
        PressaoInicial = Pvent;
        VolumeInicial = VR+PressaoInicial/E;
        %Condi��o do Delay
        PressaoDelay = Pvent;
        
        %% Simula��o
        for Configuracao = 1:1:4
            if Configuracao == 1
                Delay = 0.050;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 2
                Delay = 0.050;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 3
                Delay = 0.100;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 4
                Delay = 0.100;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                                
            end
        end
        
    elseif Paciente == 4
        %% Paciente 4 - Paciente com Doen�a Obstrutiva
        %Elast�ncia (cm H2O /L)
        E = 1/0.120;
        %Resist�ncia das vias aereas (cm H2O / L/s)
        Rrs = 25;
        
        %% Condi��es iniciais
        %Condi��o do Integrador
        PressaoInicial = Pvent;
        VolumeInicial = VR+PressaoInicial/E;
        %Condi��o do Delay
        PressaoDelay = Pvent;
        
        %% Simula��o
        for Configuracao = 1:1:4
            if Configuracao == 1
                Delay = 0.050;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 2
                Delay = 0.050;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 3
                Delay = 0.100;
                Ptrigger = 0.5;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                
            elseif Configuracao == 4
                Delay = 0.100;
                Ptrigger = 1.0;
                
                for TOTeSonda = 1:1:7
                    if TOTeSonda == 1
                        TOT = 7.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 2
                        TOT = 7.5;
                        Tamanho_Sonda = 08;
                       
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 3
                        TOT = 7.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha

                    elseif TOTeSonda == 4
                        TOT = 8.5;
                        Tamanho_Sonda = 06;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 5
                        TOT = 8.5;
                        Tamanho_Sonda = 08;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 6
                        TOT = 8.5;
                        Tamanho_Sonda = 10;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                        
                    elseif TOTeSonda == 7
                        TOT = 8.5;
                        Tamanho_Sonda = 12;
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Ideal')
                        PalvSimIdeal = PAlvSimulada.Data;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o
                        ResultadosVentiladorIdeal(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorIdeal(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorIdeal(indice,3)=TOTeSonda;%Variavel TOTeSonda
                        ResultadosVentiladorIdeal(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorIdeal(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorIdeal(indice,6)=Delay;%Delay
                        ResultadosVentiladorIdeal(indice,7)=Ptrigger;%Ptrigger
                        ResultadosVentiladorIdeal(indice,8)=TOT;%TOT
                        ResultadosVentiladorIdeal(indice,9)=Tamanho_Sonda;%Sonda
                        ResultadosVentiladorIdeal(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorIdeal(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorIdeal(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorIdeal(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorIdeal(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorIdeal(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        sim('NovoModeloControlePorPressaoRevFinal_Inter')
                        PalvSimInter=PAlvSimulada;
                        PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
                        PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
                        
                        %% Salvando os dados da simula��o                        
                        ResultadosVentiladorInterrupcao(indice,1)=Paciente;%Variavel Paciente
                        ResultadosVentiladorInterrupcao(indice,2)=Configuracao;%Variavel Configuracao
                        ResultadosVentiladorInterrupcao(indice,3)=TOTeSonda;%Variavel TOTeSondat
                        ResultadosVentiladorInterrupcao(indice,4)=Rrs;%Resist�ncia
                        ResultadosVentiladorInterrupcao(indice,5)=1/E;%Complacencia
                        ResultadosVentiladorInterrupcao(indice,6)=Delay;%Delay
                        ResultadosVentiladorInterrupcao(indice,7)=Ptrigger ;%Ptrigger
                        ResultadosVentiladorInterrupcao(indice,8)=TOT;%TOT
                        ResultadosVentiladorInterrupcao(indice,9)=Tamanho_Sonda ;%Sonda 
                        ResultadosVentiladorInterrupcao(indice,10)=PSemAspiracao;%CPAP
                        ResultadosVentiladorInterrupcao(indice,11)=PminAspiracao;%Pasp min
                        ResultadosVentiladorInterrupcao(indice,12)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
                        ResultadosVentiladorInterrupcao(indice,13)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
                        ResultadosVentiladorInterrupcao(indice,14)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
                        ResultadosVentiladorInterrupcao(indice,15)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
                        
                        indice = indice +1;%Proxima linha
                    end
                end
                                
            end
        end
    
    end
end

%% Plots

% Plot dos DeltaP max
figure (1)
semilogy(ResultadosVentiladorIdeal(1:28,3),ResultadosVentiladorIdeal(1:28,12),'db')
hold on
semilogy(ResultadosVentiladorIdeal(29:56,3),ResultadosVentiladorIdeal(29:56,12),'+r')
semilogy(ResultadosVentiladorIdeal(57:84,3),ResultadosVentiladorIdeal(57:84,12),'xg')
semilogy(ResultadosVentiladorIdeal(85:112,3),ResultadosVentiladorIdeal(85:112,12),'sm')
plot(0:8,2*ones(1,9),'--k')
plot(0:8,5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Limiar de \DeltaP = 2','Limiar de \DeltaP = 5','location','northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('\DeltaP_m_�_x Durante Aspira��o [cmH_2O]')


% Plot das m�dias da Palv durante aspira�ao
figure (2)
plot(ResultadosVentiladorIdeal(1:28,3),ResultadosVentiladorIdeal(1:28,13),'db')
hold on
plot(ResultadosVentiladorIdeal(29:56,3),ResultadosVentiladorIdeal(29:56,13),'+r')
plot(ResultadosVentiladorIdeal(57:84,3),ResultadosVentiladorIdeal(57:84,13),'xg')
plot(ResultadosVentiladorIdeal(85:112,3),ResultadosVentiladorIdeal(85:112,13),'sm')
plot(0:8,5*ones(1,9),'--k')
plot(0:8,zeros(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Limiar de P_a_l_v_e_o_l_a_r=5cmH_2O','Limiar de P_a_l_v_e_o_l_a_r=0cmH_2O','location','Southwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Press�o_M_�_d_i_a Durante Aspira��o [cmH_2O]')


% Plot da maior vaz�o de aspira��o durante a aspira��o
figure (3)
plot(ResultadosVentiladorIdeal(1:28,3),-ResultadosVentiladorIdeal(1:28,14),'db')
hold on
plot(ResultadosVentiladorIdeal(29:56,3),-ResultadosVentiladorIdeal(29:56,14),'+r')
plot(ResultadosVentiladorIdeal(57:84,3),-ResultadosVentiladorIdeal(57:84,14),'xg')
plot(ResultadosVentiladorIdeal(85:112,3),-ResultadosVentiladorIdeal(85:112,14),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_x [L/s]')
title('a')

% Plot da m�dia da vaz�o de aspira��o durante a aspira��o
figure (4)
plot(ResultadosVentiladorIdeal(1:28,3),-ResultadosVentiladorIdeal(1:28,15),'db')
hold on
plot(ResultadosVentiladorIdeal(29:56,3),-ResultadosVentiladorIdeal(29:56,15),'+r')
plot(ResultadosVentiladorIdeal(57:84,3),-ResultadosVentiladorIdeal(57:84,15),'xg')
plot(ResultadosVentiladorIdeal(85:112,3),-ResultadosVentiladorIdeal(85:112,15),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_d_i_a [L/s]')
title('b')

% Plot dos DeltaP max
figure (5)
semilogy(ResultadosVentiladorInterrupcao(1:28,3),ResultadosVentiladorInterrupcao(1:28,12),'db')
hold on
semilogy(ResultadosVentiladorInterrupcao(29:56,3),ResultadosVentiladorInterrupcao(29:56,12),'+r')
semilogy(ResultadosVentiladorInterrupcao(57:84,3),ResultadosVentiladorInterrupcao(57:84,12),'xg')
semilogy(ResultadosVentiladorInterrupcao(85:112,3),ResultadosVentiladorInterrupcao(85:112,12),'sm')
plot(0:8,2*ones(1,9),'--k')
plot(0:8,5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Limiar de \DeltaP = 2','Limiar de \DeltaP = 5','location','southeast')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('\DeltaP_m_�_x Durante Aspira��o [cmH_2O]')


% Plot das m�dias da Palv durante aspira�ao
figure (6)
plot(ResultadosVentiladorInterrupcao(1:28,3),ResultadosVentiladorInterrupcao(1:28,13),'db')
hold on
plot(ResultadosVentiladorInterrupcao(29:56,3),ResultadosVentiladorInterrupcao(29:56,13),'+r')
plot(ResultadosVentiladorInterrupcao(57:84,3),ResultadosVentiladorInterrupcao(57:84,13),'xg')
plot(ResultadosVentiladorInterrupcao(85:112,3),ResultadosVentiladorInterrupcao(85:112,13),'sm')
plot(0:8,5*ones(1,9),'--k')
plot(0:8,zeros(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Limiar de P_a_l_v_e_o_l_a_r=5cmH_2O','Limiar de P_a_l_v_e_o_l_a_r=0cmH_2O','location','Southwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Press�o_M_�_d_i_a Durante Aspira��o [cmH_2O]')


% Plot da maior vaz�o de aspira��o durante a aspira��o
figure (7)
plot(ResultadosVentiladorInterrupcao(1:28,3),-ResultadosVentiladorInterrupcao(1:28,14),'db')
hold on
plot(ResultadosVentiladorInterrupcao(29:56,3),-ResultadosVentiladorInterrupcao(29:56,14),'+r')
plot(ResultadosVentiladorInterrupcao(57:84,3),-ResultadosVentiladorInterrupcao(57:84,14),'xg')
plot(ResultadosVentiladorInterrupcao(85:112,3),-ResultadosVentiladorInterrupcao(85:112,14),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_x [L/s]')
title('a')

% Plot da m�dia da vaz�o de aspira��o durante a aspira��o
figure (8)
plot(ResultadosVentiladorInterrupcao(1:28,3),-ResultadosVentiladorInterrupcao(1:28,15),'db')
hold on
plot(ResultadosVentiladorInterrupcao(29:56,3),-ResultadosVentiladorInterrupcao(29:56,15),'+r')
plot(ResultadosVentiladorInterrupcao(57:84,3),-ResultadosVentiladorInterrupcao(57:84,15),'xg')
plot(ResultadosVentiladorInterrupcao(85:112,3),-ResultadosVentiladorInterrupcao(85:112,15),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_d_i_a [L/s]')
title('b')

% plot(PalvSimIdeal.Time,PalvSimIdeal.Data,'b')
% hold on
% plot(PalvSimInter.Time,PalvSimInter.Data,'r')

%% Aspira��o intermitente
IndiceVentiladorIdeal = zeros(1,112);
IndiceVentiladorInterrupcao = zeros(1,112);
for i=1:112
    if ResultadosVentiladorIdeal(i,12) > 2
        IndiceVentiladorIdeal(i) = i;
    end
    if ResultadosVentiladorInterrupcao(i,12) > 2
        IndiceVentiladorInterrupcao(i) = i;
    end
end
    
%Retira os zeros do indice
Condicao = IndiceVentiladorIdeal(:)==0;
IndiceVentiladorIdeal(Condicao) = [];

Condicao = IndiceVentiladorInterrupcao(:)==0;
IndiceVentiladorInterrupcao(Condicao) = [];

ResultadosVentiladorIdealIntermitente = zeros (2*length(IndiceVentiladorIdeal),16);
ResultadosVentiladorInterrupcaoIntermitente = zeros (2*length(IndiceVentiladorInterrupcao),16);
%Montagem das Matrizes
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,1)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),1);%Variavel Paciente
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,2)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),2);%Variavel Configuracao
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,3)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),3);%Variavel TOTeSonda
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,4)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),4);%Resist�ncia
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,5)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),5);%Complacencia
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,6)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),6);%Delay
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,7)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),7);%Ptrigger
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,8)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),8);%TOT
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,9)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),9);%Sonda
ResultadosVentiladorIdealIntermitente(1:2:2*length(IndiceVentiladorIdeal)-1,10)=1;%Frequencia de Aspira��o
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),1)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),1);%Variavel Paciente
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),2)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),2);%Variavel Configuracao
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),3)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),3);%Variavel TOTeSonda
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),4)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),4);%Resist�ncia
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),5)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),5);%Complacencia
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),6)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),6);%Delay
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),7)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),7);%Ptrigger
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),8)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),8);%TOT
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),9)=ResultadosVentiladorIdeal(IndiceVentiladorIdeal(:),9);%Sonda
ResultadosVentiladorIdealIntermitente(2:2:2*length(IndiceVentiladorIdeal),10)=2;%Frequencia de Aspira��o

ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,1)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),1);%Variavel Paciente
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,2)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),2);%Variavel Configuracao
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,3)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),3);%Variavel TOTeSonda
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,4)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),4);%Resist�ncia
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,5)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),5);%Complacencia
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,6)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),6);%Delay
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,7)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),7);%Ptrigger
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,8)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),8);%TOT
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,9)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),9);%Sonda
ResultadosVentiladorInterrupcaoIntermitente(1:2:2*length(IndiceVentiladorInterrupcao)-1,10)=1;%Frequencia de Aspira��o
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),1)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),1);%Variavel Paciente
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),2)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),2);%Variavel Configuracao
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),3)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),3);%Variavel TOTeSonda
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),4)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),4);%Resist�ncia
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),5)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),5);%Complacencia
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),6)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),6);%Delay
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),7)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),7);%Ptrigger
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),8)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),8);%TOT
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),9)=ResultadosVentiladorInterrupcao(IndiceVentiladorInterrupcao(:),9);%Sonda
ResultadosVentiladorInterrupcaoIntermitente(2:2:2*length(IndiceVentiladorInterrupcao),10)=2;%Frequencia de Aspira��o

%% Inicio das simula��es intermitentes
%Aspira��o Intermitente
Habilitar = 1; %Habilitado
Hz = 1; %Valor de Default (Hz)

for i=1:length(ResultadosVentiladorIdealIntermitente)
    %Elast�ncia (cm H2O /L)
    E = 1/ResultadosVentiladorIdealIntermitente(i,5);
    %Resist�ncia das vias aereas (cm H2O / L/s)
    Rrs = ResultadosVentiladorIdealIntermitente(i,4);
    %% Condi��es iniciais
    %Condi��o do Integrador
    PressaoInicial = Pvent;
    VolumeInicial = VR+PressaoInicial/E;
    %Condi��o do Delay
    PressaoDelay = Pvent;
    Delay = ResultadosVentiladorIdealIntermitente(i,6);
    Ptrigger = ResultadosVentiladorIdealIntermitente(i,7);
    TOT = ResultadosVentiladorIdealIntermitente(i,8);
    Tamanho_Sonda = ResultadosVentiladorIdealIntermitente(i,9);
    Hz = ResultadosVentiladorIdealIntermitente(i,10);
    
    sim('NovoModeloControlePorPressaoRevFinal_Ideal')
    PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
    PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
    
    ResultadosVentiladorIdealIntermitente(i,11)=PSemAspiracao;%CPAP
    ResultadosVentiladorIdealIntermitente(i,12)=PminAspiracao;%Pasp min
    ResultadosVentiladorIdealIntermitente(i,13)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
    ResultadosVentiladorIdealIntermitente(i,14)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
    ResultadosVentiladorIdealIntermitente(i,15)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
    ResultadosVentiladorIdealIntermitente(i,16)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
end

for i=1:length(ResultadosVentiladorInterrupcaoIntermitente)
    %Elast�ncia (cm H2O /L)
    E = 1/ResultadosVentiladorInterrupcaoIntermitente(i,5);
    %Resist�ncia das vias aereas (cm H2O / L/s)
    Rrs = ResultadosVentiladorInterrupcaoIntermitente(i,4);
    %% Condi��es iniciais
    %Condi��o do Integrador
    PressaoInicial = Pvent;
    VolumeInicial = VR+PressaoInicial/E;
    %Condi��o do Delay
    PressaoDelay = Pvent;
    Delay = ResultadosVentiladorInterrupcaoIntermitente(i,6);
    Ptrigger = ResultadosVentiladorInterrupcaoIntermitente(i,7);
    TOT = ResultadosVentiladorInterrupcaoIntermitente(i,8);
    Tamanho_Sonda = ResultadosVentiladorInterrupcaoIntermitente(i,9);
    Hz = ResultadosVentiladorInterrupcaoIntermitente(i,10);
    
    sim('NovoModeloControlePorPressaoRevFinal_Inter')
    PSemAspiracao = mean(PAlvSimulada.Data(59001:60000)); %Calculo da Press�o de CPAP da Aspira��o
    PminAspiracao = min(PAlvSimulada.Data(60001:75000)); %Calculo da Press�o Durante da Aspira��o (pegando o menor valor para ver o maior impacto)
    
    ResultadosVentiladorInterrupcaoIntermitente(i,11)=PSemAspiracao;%CPAP
    ResultadosVentiladorInterrupcaoIntermitente(i,12)=PminAspiracao;%Pasp min
    ResultadosVentiladorInterrupcaoIntermitente(i,13)=PSemAspiracao-PminAspiracao;%DeltaP = CPAP-Pasp min
    ResultadosVentiladorInterrupcaoIntermitente(i,14)=mean(PAlvSimulada.Data(60001:75000));%Media da Pasp durante aspira��o
    ResultadosVentiladorInterrupcaoIntermitente(i,15)=min(VazaoAsp.Data);%Maior Vaz�o de aspira��o
    ResultadosVentiladorInterrupcaoIntermitente(i,16)=mean(VazaoAsp.Data(60001:75000));%Media da Vaz�o de aspira��o durante aspira��o
end

%Criando indice logico para plots
Paciente1_Vent_Ideal_Inter_1Hz = ResultadosVentiladorIdealIntermitente(:,1)==1 & ResultadosVentiladorIdealIntermitente(:,10)==1;
Paciente1_Vent_Ideal_Inter_2Hz = ResultadosVentiladorIdealIntermitente(:,1)==1 & ResultadosVentiladorIdealIntermitente(:,10)==2;
Paciente2_Vent_Ideal_Inter_1Hz = ResultadosVentiladorIdealIntermitente(:,1)==2 & ResultadosVentiladorIdealIntermitente(:,10)==1;
Paciente2_Vent_Ideal_Inter_2Hz = ResultadosVentiladorIdealIntermitente(:,1)==2 & ResultadosVentiladorIdealIntermitente(:,10)==2;
Paciente3_Vent_Ideal_Inter_1Hz = ResultadosVentiladorIdealIntermitente(:,1)==3 & ResultadosVentiladorIdealIntermitente(:,10)==1;
Paciente3_Vent_Ideal_Inter_2Hz = ResultadosVentiladorIdealIntermitente(:,1)==3 & ResultadosVentiladorIdealIntermitente(:,10)==2;
Paciente4_Vent_Ideal_Inter_1Hz = ResultadosVentiladorIdealIntermitente(:,1)==4 & ResultadosVentiladorIdealIntermitente(:,10)==1;
Paciente4_Vent_Ideal_Inter_2Hz = ResultadosVentiladorIdealIntermitente(:,1)==4 & ResultadosVentiladorIdealIntermitente(:,10)==2;

Paciente1_Vent_Inter_Inter_1Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==1 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==1;
Paciente1_Vent_Inter_Inter_2Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==1 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==2;
Paciente2_Vent_Inter_Inter_1Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==2 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==1;
Paciente2_Vent_Inter_Inter_2Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==2 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==2;
Paciente3_Vent_Inter_Inter_1Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==3 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==1;
Paciente3_Vent_Inter_Inter_2Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==3 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==2;
Paciente4_Vent_Inter_Inter_1Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==4 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==1;
Paciente4_Vent_Inter_Inter_2Hz = ResultadosVentiladorInterrupcaoIntermitente(:,1)==4 & ResultadosVentiladorInterrupcaoIntermitente(:,10)==2;

%% Plots

% Plot dos DeltaP max
figure (21)
semilogy(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,13),'db')
hold on
semilogy(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,13),'+r')
semilogy(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,13),'xg')
semilogy(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,13),'sm')
plot(0:8,2*ones(1,9),'--k')
plot(0:8,5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Limiar de \DeltaP = 2','Limiar de \DeltaP = 5','location','northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('\DeltaP_m_�_x Durante Aspira��o [cmH_2O]')
title ('a')
figure (22)
semilogy(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,13),'db')
hold on
semilogy(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,13),'+r')
semilogy(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,13),'xg')
semilogy(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,13),'sm')
plot(0:8,2*ones(1,9),'--k')
plot(0:8,5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Limiar de \DeltaP = 2','Limiar de \DeltaP = 5','location','northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('\DeltaP_m_�_x Durante Aspira��o [cmH_2O]')
title ('b')

% Plot das m�dias da Palv durante aspira�ao
figure (23)
plot(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,14),'db')
hold on
plot(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,14),'+r')
plot(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,14),'xg')
plot(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,3),ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,14),'sm')
plot(0:8,5*ones(1,9),'--k')
plot(0:8,zeros(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Limiar de P_a_l_v_e_o_l_a_r=5cmH_2O','Limiar de P_a_l_v_e_o_l_a_r=0cmH_2O','location','Southwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Press�o_M_�_d_i_a Durante Aspira��o [cmH_2O]')
title ('a')
ylim([-6 10])
figure (24)
plot(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,14),'db')
hold on
plot(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,14),'+r')
plot(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,14),'xg')
plot(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,3),ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,14),'sm')
plot(0:8,5*ones(1,9),'--k')
plot(0:8,zeros(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Limiar de P_a_l_v_e_o_l_a_r=5cmH_2O','Limiar de P_a_l_v_e_o_l_a_r=0cmH_2O','location','Southwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Press�o_M_�_d_i_a Durante Aspira��o [cmH_2O]')
title ('b')
ylim([-6 10])


% Plot da maior vaz�o de aspira��o durante a aspira��o
figure (25)
plot(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,15),'db')
hold on
plot(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,15),'+r')
plot(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,15),'xg')
plot(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,15),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_x [L/s]')
title('a')
figure (26)
plot(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,15),'db')
hold on
plot(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,15),'+r')
plot(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,15),'xg')
plot(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,15),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_x [L/s]')
title('b')

% Plot da m�dia da vaz�o de aspira��o durante a aspira��o
figure (27)
plot(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_1Hz,16),'db')
hold on
plot(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_1Hz,16),'+r')
plot(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_1Hz,16),'xg')
plot(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_1Hz,16),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_d_i_a [L/s]')
title('c')
ylim([0 0.55])
figure (28)
plot(ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente1_Vent_Ideal_Inter_2Hz,16),'db')
hold on
plot(ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente2_Vent_Ideal_Inter_2Hz,16),'+r')
plot(ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente3_Vent_Ideal_Inter_2Hz,16),'xg')
plot(ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,3),-ResultadosVentiladorIdealIntermitente(Paciente4_Vent_Ideal_Inter_2Hz,16),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorIdeal(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorIdeal(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorIdeal(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_d_i_a [L/s]')
title('d')
ylim([0 0.55])

% Plot dos DeltaP max
figure (29)
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,13),'db')
hold on
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,13),'+r')
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,13),'xg')
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,13),'sm')
plot(0:8,2*ones(1,9),'--k')
plot(0:8,5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Limiar de \DeltaP = 2','Limiar de \DeltaP = 5','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('\DeltaP_m_�_x Durante Aspira��o [cmH_2O]')
title('a')
figure (30)
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,13),'db')
hold on
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,13),'+r')
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,13),'xg')
semilogy(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,13),'sm')
plot(0:8,2*ones(1,9),'--k')
plot(0:8,5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Limiar de \DeltaP = 2','Limiar de \DeltaP = 5','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('\DeltaP_m_�_x Durante Aspira��o [cmH_2O]')
title('b')

% Plot das m�dias da Palv durante aspira�ao
figure (31)
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,14),'db')
hold on
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,14),'+r')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,14),'xg')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,14),'sm')
plot(0:8,5*ones(1,9),'--k')
plot(0:8,zeros(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Limiar de P_a_l_v_e_o_l_a_r=5cmH_2O','Limiar de P_a_l_v_e_o_l_a_r=0cmH_2O','location','Southwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Press�o_M_�_d_i_a Durante Aspira��o [cmH_2O]')
title('a')
figure (32)
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,14),'db')
hold on
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,14),'+r')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,14),'xg')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,3),ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,14),'sm')
plot(0:8,5*ones(1,9),'--k')
plot(0:8,zeros(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Limiar de P_a_l_v_e_o_l_a_r=5cmH_2O','Limiar de P_a_l_v_e_o_l_a_r=0cmH_2O','location','Southwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Press�o_M_�_d_i_a Durante Aspira��o [cmH_2O]')
title('b')

% Plot da maior vaz�o de aspira��o durante a aspira��o
figure (33)
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,15),'db')
hold on
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,15),'+r')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,15),'xg')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,15),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_x [L/s]')
title('a')
ylim([0 0.7])
figure (34)
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,15),'db')
hold on
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,15),'+r')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,15),'xg')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,15),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_x [L/s]')
title('b')
ylim([0 0.7])

% Plot da m�dia da vaz�o de aspira��o durante a aspira��o
figure (35)
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_1Hz,16),'db')
hold on
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_1Hz,16),'+r')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_1Hz,16),'xg')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_1Hz,16),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_d_i_a [L/s]')
title('c')
ylim([0 0.55])
figure (36)
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente1_Vent_Inter_Inter_2Hz,16),'db')
hold on
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente2_Vent_Inter_Inter_2Hz,16),'+r')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente3_Vent_Inter_Inter_2Hz,16),'xg')
plot(ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,3),-ResultadosVentiladorInterrupcaoIntermitente(Paciente4_Vent_Inter_Inter_2Hz,16),'sm')
plot(0:8,0.5*ones(1,9),'--r')
hold off
legend(['R=' num2str(ResultadosVentiladorInterrupcao(1,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(1,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(29,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(29,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(57,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(57,5)*1000) 'mL/cmH_2O'],['R=' num2str(ResultadosVentiladorInterrupcao(85,4)) 'cmH_2O/L/s C=' num2str(ResultadosVentiladorInterrupcao(85,5)*1000) 'mL/cmH_2O'],'Satura��o de Vaz�o=0.5L/s','location','Northwest')
labels = {' ','T7.5 S06','T7.5 S08','T7.5 S10','T8.5 S06','T8.5 S08','T8.5 S10','T8.5 S12',' '};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
set(gca, 'XTick', [0:8], 'XTickLabel', labels)
ylabel('Vaz�o de Aspira��o_m_�_d_i_a [L/s]')
title('d')
ylim([0 0.55])

% % % %112 linhas = 4 Pacientes x 4 Configura��es x 7 TOT e Sondas
% % % %1� coluna = n�mero de 1 a 4 de configura�aode E e Rrs (Variavel Paciente)
% % % %2� coluna = n�mero de 1 a 4 de configura��o de Delay e Ptrigger (Variavel Configuracao)
% % % %3� coluna = N�mero de 1 a 7 de combina�ao de TOT e Sonda para plot (Variavel TOTeSonda)
% % % %4� a 9� colunas = Classifica��o - Rrs / Crs / Delay / PTrigger / TOT / Sonda
% % % %10� coluna = Palv sem aspira��o (CPAP)
% % % %11� coluna = Palv min na aspira��o
% % % %12� coluna = DeltaP max = Palv sem aspira��o - Palv min na aspira��o
% % % %13� coluna = M�dia da Palv durante a aspira��o
% % % %14� coluna = min (Vaz�o Asp) = Maior vaz�o de aspira��o
% % % %15� coluna = M�dia da vaz�o durante a aspira��o
