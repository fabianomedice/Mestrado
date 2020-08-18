clc
clear all

[P761, Tpulmao70601, Ppulmao70601, Index70601, PmedAsp70601, PmedVent70601, PmedPulmao70601] = Leitura('E06FR001_TOT7.5_Vet.txt');

for Indice_PEEP=0:2
    %% Criação dos Sinais
    T70601 = [Tpulmao70601(1+Indice_PEEP*3),1:Index70601(1+Indice_PEEP*3))-Tpulmao70601(1+Indice_PEEP*3,1) Tpulmao70601(2+Indice_PEEP*3,1:Index70601(2+Indice_PEEP*3))-Tpulmao70601(1+Indice_PEEP*3,1) Tpulmao70601(3+Indice_PEEP*3,1:Index70601(3+Indice_PEEP*3))-Tpulmao70601(1+Indice_PEEP*3,1)];
    P70601 = [Ppulmao70601(1+Indice_PEEP*3,1:Index70601(1+Indice_PEEP*3)) Ppulmao70601(2+Indice_PEEP*3,1:Index70601(2+Indice_PEEP*3)) Ppulmao70601(3+Indice_PEEP*3,1:Index70601(3+Indice_PEEP*3))];
    T70602 = [Tpulmao70602(1+Indice_PEEP*3,1:Index70602(1+Indice_PEEP*3))-Tpulmao70602(1+Indice_PEEP*3,1) Tpulmao70602(2+Indice_PEEP*3,1:Index70602(2+Indice_PEEP*3))-Tpulmao70602(1+Indice_PEEP*3,1) Tpulmao70602(3+Indice_PEEP*3,1:Index70602(3+Indice_PEEP*3))-Tpulmao70602(1+Indice_PEEP*3,1)];
    P70602 = [Ppulmao70602(1+Indice_PEEP*3,1:Index70602(1+Indice_PEEP*3)) Ppulmao70602(2+Indice_PEEP*3,1:Index70602(2+Indice_PEEP*3)) Ppulmao70602(3+Indice_PEEP*3,1:Index70602(3+Indice_PEEP*3))];
    T70603 = [Tpulmao70603(1+Indice_PEEP*3,1:Index70603(1+Indice_PEEP*3))-Tpulmao70603(1+Indice_PEEP*3,1) Tpulmao70603(5+Indice_PEEP*3,1:Index70603(2+Indice_PEEP*3))-Tpulmao70603(1+Indice_PEEP*3,1) Tpulmao70603(3+Indice_PEEP*3,1:Index70603(3+Indice_PEEP*3))-Tpulmao70603(1+Indice_PEEP*3,1)];
    P70603 = [Ppulmao70603(1+Indice_PEEP*3,1:Index70603(1+Indice_PEEP*3)) Ppulmao70603(2+Indice_PEEP*3,1:Index70603(2+Indice_PEEP*3)) Ppulmao70603(3+Indice_PEEP*3,1:Index70603(3+Indice_PEEP*3))];
    
    %Criação dos timestamp para sincronização
    P70601 = timetable(T70601',P70601','VariableNames',{'Pressure'});
    P70602 = timetable(T70602',P70602','VariableNames',{'Pressure'});
    P70603 = timetable(T70603',P70603','VariableNames',{'Pressure'});
    
    %Montagem dos grupos de dados
    P706 = synchronize(P70601,P70602,P70603,'union','previous');
    
    %% Configurando a simulação
    %Tempo da Simulação (seg) - Tempo total da simulação no simulink
    Tsimulacao = 5+15+20+15+20+15+5;
    %Tempo de amostragem (seg) - Tempo para cada calculo do simulink
    Tamostra = 0.001;
    %Pressão do Ventilador (cm H20)
    Pvent = 5+Indice_PEEP*5; %Pvent ideal
    
    %Calculo da pressão de aspiração
    Pasp = [mean([PmedAsp70601(1+Indice_PEEP*3) PmedAsp70602(1+Indice_PEEP*3) PmedAsp70603(1+Indice_PEEP*3)]), mean([PmedAsp70601(2+Indice_PEEP*3) PmedAsp70602(2+Indice_PEEP*3) PmedAsp70603(2+Indice_PEEP*3)]), mean([PmedAsp70601(3+Indice_PEEP*3) PmedAsp70602(3+Indice_PEEP*3) PmedAsp70603(3+Indice_PEEP*3)])];
    
    %Dados do paciente
    E=38.1970;
    Rrs=3.3464;
    VR=0;
    
    % % Condições iniciais
    %Condição do Integrador
    PressaoInicial = Pvent;
    VolumeInicial = VR+PressaoInicial/E;
    %Condição do Delay
    PressaoDelay = Pvent;
    Delay = 0.5;
    Ptrigger = 0.5;
    %Sondas 06
    TOT = 7.5;
    Tamanho_Sonda = 06;
    PaspMin = Pasp(1,1);
    PaspMed = Pasp(1,2);
    PaspMax = Pasp(1,3);
    sim('ModeloControlePorPressaoRevFinal_Validacao')
    Psim706=PressaoSimulada;
    
    %% Calculo das diferenças de pressões médias durante a aspiração
    PmedVent = [mean([PmedVent70601(1+Indice_PEEP*3) PmedVent70602(1+Indice_PEEP*3) PmedVent70603(1+Indice_PEEP*3)]), mean([PmedVent70601(2+Indice_PEEP*3) PmedVent70602(2+Indice_PEEP*3) PmedVent70603(2+Indice_PEEP*3)]), mean([PmedVent70601(3+Indice_PEEP*3) PmedVent70602(3+Indice_PEEP*3) PmedVent70603(3+Indice_PEEP*3)])];
    
    PmedPulmao = [mean([PmedPulmao70601(1+Indice_PEEP*3) PmedPulmao70602(1+Indice_PEEP*3) PmedPulmao70603(1+Indice_PEEP*3)]), mean([PmedPulmao70601(2+Indice_PEEP*3) PmedPulmao70602(2+Indice_PEEP*3) PmedPulmao70603(2+Indice_PEEP*3)]), mean([PmedPulmao70601(3+Indice_PEEP*3) PmedPulmao70602(3+Indice_PEEP*3) PmedPulmao70603(3+Indice_PEEP*3)])];
    
    PsimPulmao = [Psim706.Data(12501), Psim706.Data(47501), Psim706.Data(82501)];
    
    DifPVentPulmao = PmedVent - PmedPulmao;%Diferença entre a pressão media de ventilação com o do pulmao
    DifPPulmaoSim = PmedPulmao - PsimPulmao;%Diferença entre a pressão experimental e pressão simulada
    DifVentSimDifPsim = 10*ones(size(PsimPulmao)) - PsimPulmao;%Diferença entre a pressão simulada do ventilador com a pressão simulada alveolar
    
    %% Fazendo a correlação dos sinais
    
    %%Para a função CorrelacaoInd
    Corr706 = zeros(1,4);
    [Corr706(1,1), Corr706(1,2), Corr706(1,3), Corr706(1,4)]= CorrelacaoInd(Psim706,P706);
    
    %% Plots de comparação
    figure ()
    plot(Pasp',DifPPulmaoSim','*-')
    legend('TOT7.5 06FR','TOT7.5 08FR','TOT7.5 10FR','TOT8.5 06FR','TOT8.5 08FR','TOT8.5 10FR','TOT8.5 12FR','location','best')
    xlabel('Pasp')
    ylabel('Palv experimental - Palv simulada')
    title('A')
    
    figure ()
    plot(Pasp',DifPVentPulmao','*-')
    legend('TOT7.5 06FR','TOT7.5 08FR','TOT7.5 10FR','TOT8.5 06FR','TOT8.5 08FR','TOT8.5 10FR','TOT8.5 12FR','location','best')
    xlabel('Pasp')
    ylabel('Pvent experimental - Palv experimental')
    % ylim ([0 0.6])
    title('B')
    
    figure ()
    plot(Pasp',DifVentSimDifPsim','*-')
    legend('TOT7.5 06FR','TOT7.5 08FR','TOT7.5 10FR','TOT8.5 06FR','TOT8.5 08FR','TOT8.5 10FR','TOT8.5 12FR','location','best')
    xlabel('Pasp')
    ylabel('Pvent simulada - Palv simulada')
    % ylim ([0 0.6])
    title('C')
end