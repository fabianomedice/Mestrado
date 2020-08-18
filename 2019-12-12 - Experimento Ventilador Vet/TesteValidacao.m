clc
clear all
close all


% for i=1:3
    for i=1:6
    %% Leitura dos Dados
    
    %Chamada da sonda
    if i == 1
        Name = 'E12FR001_TOT8.5';
    elseif i==2
        Name = 'E12FR002_TOT8.5';
    elseif i==3
        Name = 'E12FR003_TOT8.5';
    elseif i==4
        Name = 'M12FR001_TOT8.5';
    elseif i==5
        Name = 'M12FR002_TOT8.5';
    elseif i==6
        Name = 'M12FR003_TOT8.5';
    end
    
    %% Sistema Fechado
    % comma2point_overwrite([Name '_F.txt'])
    % Dados = dlmread([Name '_F.txt']);
    comma2point_overwrite([Name '_Vet.txt'])
    Dados = dlmread([Name '_Vet.txt']);
    
    Time1 = Dados(:,1);
    Time2 = Dados(:,4);
    Time3 = Dados(:,7);
    Pressure1 = 5*Dados(:,3);
    Pressure2 = Dados(:,6);
    Pressure3 = Dados(:,9);
    Flow1 = Dados(:,2);
    Flow2 = Dados(:,5);
    Flow3 = Dados(:,8);
    
    %%------------------------------------
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
    
    
    %%Filtros
    Fc = 1; %frequencia de corte
    Fa = 100;%frequencia de amostragem
    [B, A]=butter(2,2*Fc/Fa);
    Pressure1 = filtfilt(B,A,Pressure1);
    Flow1 = filtfilt(B,A,Flow1);
    Pressure2 = filtfilt(B,A,Pressure2);
    Flow2 = filtfilt(B,A,Flow2);
    Pressure3 = filtfilt(B,A,Pressure3);
    Flow3 = filtfilt(B,A,Flow3);
    
    %%------------------------------------
    % Criando o time series
    %%-------------------------------------
    
    VentilationF = timetable(seconds(Time1),Pressure1,Flow1,'VariableNames',{'Pressure','Flow'});
    LungF = timetable(seconds(Time2),Pressure2,Flow2,'VariableNames',{'Pressure','Flow'});
    SuctionF = timetable(seconds(Time3),Pressure3,Flow3,'VariableNames',{'Pressure','Flow'});
    
    %synchronize %sincroniza os dados
    DataF = synchronize(VentilationF,LungF,SuctionF,'union','previous');
    VentilationF = [Time1 Pressure1];
    SuctionF = [Time3 Pressure3];
    
    %% ------------------------------------
    % Simulação
    %%-------------------------------------
    
    %Simulação para sistema fechado
    
    % Configurando a simulação
    %Tempo da Simulação (seg) - Tempo total da simulação no simulink
    % % % Tsimulacao = 5+15+20+15+20+15+5;
    Tsimulacao = floor(SuctionF(end,1));
    %Tempo de amostragem (seg) - Tempo para cada calculo do simulink
    Tamostra = 0.001;
    %Pressão do Ventilador (cm H20)
    Pvent = 0; %Patm %Substituido pelo o sinal de pressão do ventilador
    TOT = str2num(Name(13:15));
    Tamanho_Sonda = str2num(Name(2:3));
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
    Delay = 0.0;%Não faz sentido ter pq já to usando o sinal do ventilador
    Ptrigger = -0.0;%Não faz sentido ter pq já to usando o sinal do ventilador
    sim('ModeloControlePorPressaoRevFinal_ValidacaoFechado')
    PsimF=PressaoSimulada;
    
    %     figure()
    %     plot(seconds(PsimF.Time),PsimF.Data,'r',DataF.Time,DataF.Pressure_LungF,'b')
    %     legend('Simulado','Real','location','best')
    %     xlabel('Tempo')
    %     ylabel('Pressão')
    %     title(['Simulação Sistema Fechado de ' Name])
    
    %
    
    %% Criando o vetor de correlação e analise
    %Cria o timetable do sinal simulado
    Sinalsim = 0;
    Sinalsim = timetable(seconds(PsimF.Time),PsimF.Data,'VariableNames',{'PressureSim'});
    %Sincroniza os sinais
    Analise = 0;
    Analise = synchronize(Sinalsim,DataF,'union','previous');
    
    
    %Chamada das Pressões
    if i == 1
        c1=max(crosscorr(Analise.PressureSim,Analise.Pressure_LungF,min([length(Analise.PressureSim) length(Analise.Pressure_LungF)])-1));
        Pr1 = Analise.Pressure_LungF;
        Ps1 = Analise.PressureSim;
        Mean1 = mean(Ps1-Pr1);
        Std1 = std(Ps1-Pr1);
    elseif i==2
        c2=max(crosscorr(Analise.PressureSim,Analise.Pressure_LungF,min([length(Analise.PressureSim) length(Analise.Pressure_LungF)])-1));
        Pr2 = Analise.Pressure_LungF;
        Ps2 = Analise.PressureSim;
        Mean2 = mean(Ps2-Pr2);
        Std2 = std(Ps2-Pr2);
    elseif i==3
        c3=max(crosscorr(Analise.PressureSim,Analise.Pressure_LungF,min([length(Analise.PressureSim) length(Analise.Pressure_LungF)])-1));
        Pr3 = Analise.Pressure_LungF;
        Ps3 = Analise.PressureSim;
        Mean3 = mean(Ps3-Pr3);
        Std3 = std(Ps3-Pr3);
    elseif i==4
        c4=max(crosscorr(Analise.PressureSim,Analise.Pressure_LungF,min([length(Analise.PressureSim) length(Analise.Pressure_LungF)])-1));
        Pr4 = Analise.Pressure_LungF;
        Ps4 = Analise.PressureSim;
        Mean4 = mean(Ps4-Pr4);
        Std4 = std(Ps4-Pr4);
    elseif i==5
        c5=max(crosscorr(Analise.PressureSim,Analise.Pressure_LungF,min([length(Analise.PressureSim) length(Analise.Pressure_LungF)])-1));
        Pr5 = Analise.Pressure_LungF;
        Ps5 = Analise.PressureSim;
        Mean5 = mean(Ps5-Pr5);
        Std5 = std(Ps5-Pr5);
    elseif i==6
        c6=max(crosscorr(Analise.PressureSim,Analise.Pressure_LungF,min([length(Analise.PressureSim) length(Analise.Pressure_LungF)])-1));
        Pr6 = Analise.Pressure_LungF;
        Ps6 = Analise.PressureSim;
        Mean6 = mean(Ps6-Pr6);
        Std6 = std(Ps6-Pr6);
    end
    
    %% ------------------------------------
    % Achando os intervalos
    %%-------------------------------------
    %Conferindo em todos os sinais
    
    Indice_Inicio = zeros(9,1);
    Indice_Fim = zeros(9,1);
    Limiar = 0;
    Indice = 1;
    
    for j=1:length(DataF.Pressure_SuctionF)
        if DataF.Pressure_SuctionF(j) < 0.9*mean(DataF.Pressure_SuctionF) && Limiar == 0
            %Procurando o primeiro ponto que passa pelo Limiar de 0.9*Média crescente
            Limiar = 1; %Agora não passa outro ponto
            Indice_Inicio(Indice) = j; %Salva o indice
        elseif DataF.Pressure_SuctionF(j) > 0.9*mean(DataF.Pressure_SuctionF) && Limiar == 1
            %Procurando o primeiro ponto que passa pelo Limiar de 0.9*Média decrescente
            Limiar = 0; %Agora não passa outro ponto
            Indice_Fim(Indice) = j; %Salva o indice
            Indice = Indice+1; %Prepara para o outro intervalo
        end
    end
    
    % ------------------------
    % Debugger
    % ------------------------
    
    %Corte do sinal de sinal com erro
    if Name == 'E06FR001_TOT8.5'
        %O 7 intervalo não foi uma aspiração completa então deve ser retirado
        Indice_Inicio(7) = [];
        Indice_Fim(7) = [];
    elseif Name == 'M10FR002_TOT8.5'
        %O 7 intervalo não foi uma aspiração completa então deve ser retirado
        Indice_Inicio(7) = [];
        Indice_Fim(7) = [];
    elseif Name == 'M10FR003_TOT8.5'
        %O 4 intervalo não foi uma aspiração completa então deve ser retirado
        Indice_Inicio(4) = [];
        Indice_Fim(4) = [];
    elseif Name == 'E12FR001_TOT8.5'
        %O 1 intervalo passou do limiar na ativação do sensor (erro de leitura)
        Indice_Inicio(1) = [];
        Indice_Fim(1) = [];
    elseif Name == 'M12FR001_TOT8.5'
        %O 1 intervalo passou do limiar na ativação do sensor (erro de leitura)
        Indice_Inicio(1) = [];
        Indice_Fim(1) = [];
    elseif Name == 'M12FR003_TOT8.5'
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
    
    for j=1:9
        Medias_Intervalo_Succao(j) = mean(DataF.Pressure_SuctionF(Indice_Inicio(j):Indice_Fim(j)));%Media dos intervalos
        Medias_Intervalo_Ventilacao(j) = mean(DataF.Pressure_VentilationF(Indice_Inicio(j):Indice_Fim(j)));%Media dos intervalos
        Medias_Intervalo_Pulmao(j) = mean(DataF.Pressure_LungF(Indice_Inicio(j):Indice_Fim(j)));%Media dos intervalos
        %     Maximo_Intervalo_Succao(i) = min(Data.Pressure_Suction(Indice_Inicio(i):Indice_Fim(i)));%Pressão maxima negativa de cada intervalo
    end
    
    %Calculando as pressões por intervalo para os valores finais, acima da média
    %Isto foi feito para pegar bem o patamar superior de cada curva
    PmedAsp = zeros(9,1);
    PmedVent = zeros(9,1);
    PmedPulmao = zeros(9,1);
    for k=1:9
        Somatorio_Succao = 0;
        Quantidade_Succao = 0;
        Somatorio_Ventilacao = 0;
        Quantidade_Ventilacao = 0;
        Somatorio_Pulmao = 0;
        Quantidade_Pulmao = 0;
        for j=Indice_Inicio(k):Indice_Fim(k)
            if DataF.Pressure_SuctionF(j)<Medias_Intervalo_Succao(k)
                Somatorio_Succao = Somatorio_Succao+DataF.Pressure_SuctionF(j);
                Quantidade_Succao = Quantidade_Succao+1;
            end
            if DataF.Pressure_VentilationF(j)<Medias_Intervalo_Ventilacao(k)
                Somatorio_Ventilacao = Somatorio_Ventilacao+DataF.Pressure_VentilationF(j);
                Quantidade_Ventilacao = Quantidade_Ventilacao+1;
            end
            if DataF.Pressure_LungF(j)<Medias_Intervalo_Pulmao(k)
                Somatorio_Pulmao = Somatorio_Pulmao+DataF.Pressure_LungF(j);
                Quantidade_Pulmao = Quantidade_Pulmao+1;
            end
        end
        PmedAsp(k) = Somatorio_Succao/Quantidade_Succao;
        PmedVent(k) = Somatorio_Ventilacao/Quantidade_Ventilacao;
        PmedPulmao(k) = Somatorio_Pulmao/Quantidade_Pulmao;
    end
    
    %Chamada das Pressões
    if i == 1
        PmedAsp1=PmedAsp;
        PmedVent1=PmedVent;
        PmedPulmao1=PmedPulmao;
    elseif i==2
        PmedAsp2=PmedAsp;
        PmedVent2=PmedVent;
        PmedPulmao2=PmedPulmao;
    elseif i==3
        PmedAsp3=PmedAsp;
        PmedVent3=PmedVent;
        PmedPulmao3=PmedPulmao;
    elseif i==4
        PmedAsp4=PmedAsp;
        PmedVent4=PmedVent;
        PmedPulmao4=PmedPulmao;
    elseif i==5
        PmedAsp5=PmedAsp;
        PmedVent5=PmedVent;
        PmedPulmao5=PmedPulmao;
    elseif i==6
        PmedAsp6=PmedAsp;
        PmedVent6=PmedVent;
        PmedPulmao6=PmedPulmao;
    end
    
end

%% Agrupação dos dados
% Ps = [Ps1' Ps2' Ps3'];
% Pr = [Pr1' Pr2' Pr3'];
Ps = [Ps1' Ps2' Ps3' Ps4' Ps5' Ps6'];
Pr = [Pr1' Pr2' Pr3' Pr4' Pr5' Pr6'];
PmedAsp = zeros(9,1);
PmedVent = zeros(9,1);
PmedPulmao = zeros(9,1);

% for i=1:9
%     PmedAsp(i,1) = mean([PmedAsp1(i,1) PmedAsp2(i,1) PmedAsp3(i,1)]);
%     PmedVent(i,1) = mean([PmedVent1(i,1) PmedVent2(i,1) PmedVent3(i,1)]);
%     PmedPulmao(i,1) = mean([PmedPulmao1(i,1) PmedPulmao2(i,1) PmedPulmao3(i,1)]);
% end
for i=1:9
    PmedAsp(i,1) = mean([PmedAsp1(i,1) PmedAsp2(i,1) PmedAsp3(i,1) PmedAsp4(i,1) PmedAsp5(i,1) PmedAsp6(i,1)]);
    PmedVent(i,1) = mean([PmedVent1(i,1) PmedVent2(i,1) PmedVent3(i,1) PmedVent4(i,1) PmedVent5(i,1) PmedVent6(i,1)]);
    PmedPulmao(i,1) = mean([PmedPulmao1(i,1) PmedPulmao2(i,1) PmedPulmao3(i,1) PmedPulmao4(i,1) PmedPulmao5(i,1) PmedPulmao6(i,1)]);
end
DifVentPulmao = PmedVent-PmedPulmao;

c=max(crosscorr(Ps,Pr,min([length(Ps) length(Pr)])-1));
Mean = mean(Ps-Pr);
Std = std(Ps-Pr);
        
disp({'Correlação Ind: ' c1 c2 c3})
% disp({'Correlação Ind: ' c1 c2 c3 c4 c5 c6})
disp({'Correlação Agrupada:' c})
disp({'Media Ind:' Mean1 '+-' Std1 Mean2 '+-' Std2 Mean3 '+-' Std3})
% disp({'Media Ind:' Mean1 '+-' Std1 Mean2 '+-' Std2 Mean3 '+-' Std3 Mean4 '+-' Std4 Mean5 '+-' Std5 Mean6 '+-' Std6})
disp({'Media Agrupada:' Mean '+-' Std})
disp({'PmedAsp' 'PmedVent - PmedPulmao'})
disp([PmedAsp DifVentPulmao])