%Faz a simulação e a comparação dos dados do modelo fisico e digital

clc
clear all
close all


%% Leitura dos Dados

%Codigo do Nome -> _ (TOT - 7,8) _ _ (sonda - 06,08,10) _ _ (numero - 01,02,03)
%TOT 7.5
%Sondas 06
[P761, Tpulmao70601, Ppulmao70601, Index70601, PmedAsp70601, PmedVent70601, PmedPulmao70601] = Leitura('E06FR001_TOT7.5_Vet.txt');
[P762, Tpulmao70602, Ppulmao70602, Index70602, PmedAsp70602, PmedVent70602, PmedPulmao70602] = Leitura('E06FR002_TOT7.5_Vet.txt');
[P763, Tpulmao70603, Ppulmao70603, Index70603, PmedAsp70603, PmedVent70603, PmedPulmao70603] = Leitura('E06FR003_TOT7.5_Vet.txt');
%Sondas 08
[P781, Tpulmao70801, Ppulmao70801, Index70801, PmedAsp70801, PmedVent70801, PmedPulmao70801] = Leitura('E08FR001_TOT7.5_Vet.txt');
[P782, Tpulmao70802, Ppulmao70802, Index70802, PmedAsp70802, PmedVent70802, PmedPulmao70802] = Leitura('E08FR002_TOT7.5_Vet.txt');
[P783, Tpulmao70803, Ppulmao70803, Index70803, PmedAsp70803, PmedVent70803, PmedPulmao70803] = Leitura('E08FR003_TOT7.5_Vet.txt');
%Sondas 10
[P711, Tpulmao71001, Ppulmao71001, Index71001, PmedAsp71001, PmedVent71001, PmedPulmao71001] = Leitura('M10FR001_TOT7.5_Vet.txt');
[P712, Tpulmao71002, Ppulmao71002, Index71002, PmedAsp71002, PmedVent71002, PmedPulmao71002] = Leitura('M10FR002_TOT7.5_Vet.txt');
[P713, Tpulmao71003, Ppulmao71003, Index71003, PmedAsp71003, PmedVent71003, PmedPulmao71003] = Leitura('M10FR003_TOT7.5_Vet.txt');
%TOT 8.5
%Sondas 06, 08, 10, E12, M12
%Sondas 06
[P861, Tpulmao80601, Ppulmao80601, Index80601, PmedAsp80601, PmedVent80601, PmedPulmao80601] = Leitura('E06FR001_TOT8.5_Vet.txt');
[P862, Tpulmao80602, Ppulmao80602, Index80602, PmedAsp80602, PmedVent80602, PmedPulmao80602] = Leitura('E06FR002_TOT8.5_Vet.txt');
[P863, Tpulmao80603, Ppulmao80603, Index80603, PmedAsp80603, PmedVent80603, PmedPulmao80603] = Leitura('E06FR003_TOT8.5_Vet.txt');
%Sondas 08
[P881, Tpulmao80801, Ppulmao80801, Index80801, PmedAsp80801, PmedVent80801, PmedPulmao80801] = Leitura('E08FR001_TOT8.5_Vet.txt');
[P882, Tpulmao80802, Ppulmao80802, Index80802, PmedAsp80802, PmedVent80802, PmedPulmao80802] = Leitura('E08FR002_TOT8.5_Vet.txt');
[P883, Tpulmao80803, Ppulmao80803, Index80803, PmedAsp80803, PmedVent80803, PmedPulmao80803] = Leitura('E08FR003_TOT8.5_Vet.txt');
%Sondas 10
[P8101, Tpulmao81001, Ppulmao81001, Index81001, PmedAsp81001, PmedVent81001, PmedPulmao81001] = Leitura('M10FR001_TOT8.5_Vet.txt');
[P8102, Tpulmao81002, Ppulmao81002, Index81002, PmedAsp81002, PmedVent81002, PmedPulmao81002] = Leitura('M10FR002_TOT8.5_Vet.txt');
[P8103, Tpulmao81003, Ppulmao81003, Index81003, PmedAsp81003, PmedVent81003, PmedPulmao81003] = Leitura('M10FR003_TOT8.5_Vet.txt');
%Sondas E12
[P8E1, Tpulmao81E01, Ppulmao81E01, Index81E01, PmedAsp81E01, PmedVent81E01, PmedPulmao81E01] = Leitura('E12FR001_TOT8.5_Vet.txt');
[P8E2, Tpulmao81E02, Ppulmao81E02, Index81E02, PmedAsp81E02, PmedVent81E02, PmedPulmao81E02] = Leitura('E12FR002_TOT8.5_Vet.txt');
[P8E3, Tpulmao81E03, Ppulmao81E03, Index81E03, PmedAsp81E03, PmedVent81E03, PmedPulmao81E03] = Leitura('E12FR003_TOT8.5_Vet.txt');
%Sondas M12
[P8M1, Tpulmao81M01, Ppulmao81M01, Index81M01, PmedAsp81M01, PmedVent81M01, PmedPulmao81M01] = Leitura('M12FR001_TOT8.5_Vet.txt');
[P8M2, Tpulmao81M02, Ppulmao81M02, Index81M02, PmedAsp81M02, PmedVent81M02, PmedPulmao81M02] = Leitura('M12FR002_TOT8.5_Vet.txt');
[P8M3, Tpulmao81M03, Ppulmao81M03, Index81M03, PmedAsp81M03, PmedVent81M03, PmedPulmao81M03] = Leitura('M12FR003_TOT8.5_Vet.txt');

for Indice_PEEP=0:2
    %% Criação dos Sinais
    T70601 = [Tpulmao70601(1+Indice_PEEP*3),1:Index70601(1+Indice_PEEP*3))-Tpulmao70601(1+Indice_PEEP*3,1) Tpulmao70601(2+Indice_PEEP*3,1:Index70601(2+Indice_PEEP*3))-Tpulmao70601(1+Indice_PEEP*3,1) Tpulmao70601(3+Indice_PEEP*3,1:Index70601(3+Indice_PEEP*3))-Tpulmao70601(1+Indice_PEEP*3,1)];
    P70601 = [Ppulmao70601(1+Indice_PEEP*3,1:Index70601(1+Indice_PEEP*3)) Ppulmao70601(2+Indice_PEEP*3,1:Index70601(2+Indice_PEEP*3)) Ppulmao70601(3+Indice_PEEP*3,1:Index70601(3+Indice_PEEP*3))];
    T70602 = [Tpulmao70602(1+Indice_PEEP*3,1:Index70602(1+Indice_PEEP*3))-Tpulmao70602(1+Indice_PEEP*3,1) Tpulmao70602(2+Indice_PEEP*3,1:Index70602(2+Indice_PEEP*3))-Tpulmao70602(1+Indice_PEEP*3,1) Tpulmao70602(3+Indice_PEEP*3,1:Index70602(3+Indice_PEEP*3))-Tpulmao70602(1+Indice_PEEP*3,1)];
    P70602 = [Ppulmao70602(1+Indice_PEEP*3,1:Index70602(1+Indice_PEEP*3)) Ppulmao70602(2+Indice_PEEP*3,1:Index70602(2+Indice_PEEP*3)) Ppulmao70602(3+Indice_PEEP*3,1:Index70602(3+Indice_PEEP*3))];
    T70603 = [Tpulmao70603(1+Indice_PEEP*3,1:Index70603(1+Indice_PEEP*3))-Tpulmao70603(1+Indice_PEEP*3,1) Tpulmao70603(5+Indice_PEEP*3,1:Index70603(2+Indice_PEEP*3))-Tpulmao70603(1+Indice_PEEP*3,1) Tpulmao70603(3+Indice_PEEP*3,1:Index70603(3+Indice_PEEP*3))-Tpulmao70603(1+Indice_PEEP*3,1)];
    P70603 = [Ppulmao70603(1+Indice_PEEP*3,1:Index70603(1+Indice_PEEP*3)) Ppulmao70603(2+Indice_PEEP*3,1:Index70603(2+Indice_PEEP*3)) Ppulmao70603(3+Indice_PEEP*3,1:Index70603(3+Indice_PEEP*3))];
    T70801 = [Tpulmao70801(4,1:Index70801(4))-Tpulmao70801(4,1) Tpulmao70801(5,1:Index70801(5))-Tpulmao70801(4,1) Tpulmao70801(6,1:Index70801(6))-Tpulmao70801(4,1)];
    P70801 = [Ppulmao70801(4,1:Index70801(4)) Ppulmao70801(5,1:Index70801(5)) Ppulmao70801(6,1:Index70801(6))];
    T70802 = [Tpulmao70802(4,1:Index70802(4))-Tpulmao70802(4,1) Tpulmao70802(5,1:Index70802(5))-Tpulmao70802(4,1) Tpulmao70802(6,1:Index70802(6))-Tpulmao70802(4,1)];
    P70802 = [Ppulmao70802(4,1:Index70802(4)) Ppulmao70802(5,1:Index70802(5)) Ppulmao70802(6,1:Index70802(6))];
    T70803 = [Tpulmao70803(4,1:Index70803(4))-Tpulmao70803(4,1) Tpulmao70803(5,1:Index70803(5))-Tpulmao70803(4,1) Tpulmao70803(6,1:Index70803(6))-Tpulmao70803(4,1)];
    P70803 = [Ppulmao70803(4,1:Index70803(4)) Ppulmao70803(5,1:Index70803(5)) Ppulmao70803(6,1:Index70803(6))];
    T71001 = [Tpulmao71001(4,1:Index71001(4))-Tpulmao71001(4,1) Tpulmao71001(5,1:Index71001(5))-Tpulmao71001(4,1) Tpulmao71001(6,1:Index71001(6))-Tpulmao71001(4,1)];
    P71001 = [Ppulmao71001(4,1:Index71001(4)) Ppulmao71001(5,1:Index71001(5)) Ppulmao71001(6,1:Index71001(6))];
    T71002 = [Tpulmao71002(4,1:Index71002(4))-Tpulmao71002(4,1) Tpulmao71002(5,1:Index71002(5))-Tpulmao71002(4,1) Tpulmao71002(6,1:Index71002(6))-Tpulmao71002(4,1)];
    P71002 = [Ppulmao71002(4,1:Index71002(4)) Ppulmao71002(5,1:Index71002(5)) Ppulmao71002(6,1:Index71002(6))];
    T71003 = [Tpulmao71003(4,1:Index71003(4))-Tpulmao71003(4,1) Tpulmao71003(5,1:Index71003(5))-Tpulmao71003(4,1) Tpulmao71003(6,1:Index71003(6))-Tpulmao71003(4,1)];
    P71003 = [Ppulmao71003(4,1:Index71003(4)) Ppulmao71003(5,1:Index71003(5)) Ppulmao71003(6,1:Index71003(6))];
    T80601 = [Tpulmao80601(4,1:Index80601(4))-Tpulmao80601(4,1) Tpulmao80601(5,1:Index80601(5))-Tpulmao80601(4,1) Tpulmao80601(6,1:Index80601(6))-Tpulmao80601(4,1)];
    P80601 = [Ppulmao80601(4,1:Index80601(4)) Ppulmao80601(5,1:Index80601(5)) Ppulmao80601(6,1:Index80601(6))];
    T80602 = [Tpulmao80602(4,1:Index80602(4))-Tpulmao80602(4,1) Tpulmao80602(5,1:Index80602(5))-Tpulmao80602(4,1) Tpulmao80602(6,1:Index80602(6))-Tpulmao80602(4,1)];
    P80602 = [Ppulmao80602(4,1:Index80602(4)) Ppulmao80602(5,1:Index80602(5)) Ppulmao80602(6,1:Index80602(6))];
    T80603 = [Tpulmao80603(4,1:Index80603(4))-Tpulmao80603(4,1) Tpulmao80603(5,1:Index80603(5))-Tpulmao80603(4,1) Tpulmao80603(6,1:Index80603(6))-Tpulmao80603(4,1)];
    P80603 = [Ppulmao80603(4,1:Index80603(4)) Ppulmao80603(5,1:Index80603(5)) Ppulmao80603(6,1:Index80603(6))];
    T80801 = [Tpulmao80801(4,1:Index80801(4))-Tpulmao80801(4,1) Tpulmao80801(5,1:Index80801(5))-Tpulmao80801(4,1) Tpulmao80801(6,1:Index80801(6))-Tpulmao80801(4,1)];
    P80801 = [Ppulmao80801(4,1:Index80801(4)) Ppulmao80801(5,1:Index80801(5)) Ppulmao80801(6,1:Index80801(6))];
    T80802 = [Tpulmao80802(4,1:Index80802(4))-Tpulmao80802(4,1) Tpulmao80802(5,1:Index80802(5))-Tpulmao80802(4,1) Tpulmao80802(6,1:Index80802(6))-Tpulmao80802(4,1)];
    P80802 = [Ppulmao80802(4,1:Index80802(4)) Ppulmao80802(5,1:Index80802(5)) Ppulmao80802(6,1:Index80802(6))];
    T80803 = [Tpulmao80803(4,1:Index80803(4))-Tpulmao80803(4,1) Tpulmao80803(5,1:Index80803(5))-Tpulmao80803(4,1) Tpulmao80803(6,1:Index80803(6))-Tpulmao80803(4,1)];
    P80803 = [Ppulmao80803(4,1:Index80803(4)) Ppulmao80803(5,1:Index80803(5)) Ppulmao80803(6,1:Index80803(6))];
    T81001 = [Tpulmao81001(4,1:Index81001(4))-Tpulmao81001(4,1) Tpulmao81001(5,1:Index81001(5))-Tpulmao81001(4,1) Tpulmao81001(6,1:Index81001(6))-Tpulmao81001(4,1)];
    P81001 = [Ppulmao81001(4,1:Index81001(4)) Ppulmao81001(5,1:Index81001(5)) Ppulmao81001(6,1:Index81001(6))];
    T81002 = [Tpulmao81002(4,1:Index81002(4))-Tpulmao81002(4,1) Tpulmao81002(5,1:Index81002(5))-Tpulmao81002(4,1) Tpulmao81002(6,1:Index81002(6))-Tpulmao81002(4,1)];
    P81002 = [Ppulmao81002(4,1:Index81002(4)) Ppulmao81002(5,1:Index81002(5)) Ppulmao81002(6,1:Index81002(6))];
    T81003 = [Tpulmao81003(4,1:Index81003(4))-Tpulmao81003(4,1) Tpulmao81003(5,1:Index81003(5))-Tpulmao81003(4,1) Tpulmao81003(6,1:Index81003(6))-Tpulmao81003(4,1)];
    P81003 = [Ppulmao81003(4,1:Index81003(4)) Ppulmao81003(5,1:Index81003(5)) Ppulmao81003(6,1:Index81003(6))];
    T81E01 = [Tpulmao81E01(4,1:Index81E01(4))-Tpulmao81E01(4,1) Tpulmao81E01(5,1:Index81E01(5))-Tpulmao81E01(4,1) Tpulmao81E01(6,1:Index81E01(6))-Tpulmao81E01(4,1)];
    P81E01 = [Ppulmao81E01(4,1:Index81E01(4)) Ppulmao81E01(5,1:Index81E01(5)) Ppulmao81E01(6,1:Index81E01(6))];
    T81E02 = [Tpulmao81E02(4,1:Index81E02(4))-Tpulmao81E02(4,1) Tpulmao81E02(5,1:Index81E02(5))-Tpulmao81E02(4,1) Tpulmao81E02(6,1:Index81E02(6))-Tpulmao81E02(4,1)];
    P81E02 = [Ppulmao81E02(4,1:Index81E02(4)) Ppulmao81E02(5,1:Index81E02(5)) Ppulmao81E02(6,1:Index81E02(6))];
    T81E03 = [Tpulmao81E03(4,1:Index81E03(4))-Tpulmao81E03(4,1) Tpulmao81E03(5,1:Index81E03(5))-Tpulmao81E03(4,1) Tpulmao81E03(6,1:Index81E03(6))-Tpulmao81E03(4,1)];
    P81E03 = [Ppulmao81E03(4,1:Index81E03(4)) Ppulmao81E03(5,1:Index81E03(5)) Ppulmao81E03(6,1:Index81E03(6))];
    T81M01 = [Tpulmao81M01(4,1:Index81M01(4))-Tpulmao81M01(4,1) Tpulmao81M01(5,1:Index81M01(5))-Tpulmao81M01(4,1) Tpulmao81M01(6,1:Index81M01(6))-Tpulmao81M01(4,1)];
    P81M01 = [Ppulmao81M01(4,1:Index81M01(4)) Ppulmao81M01(5,1:Index81M01(5)) Ppulmao81M01(6,1:Index81M01(6))];
    T81M02 = [Tpulmao81M02(4,1:Index81M02(4))-Tpulmao81M02(4,1) Tpulmao81M02(5,1:Index81M02(5))-Tpulmao81M02(4,1) Tpulmao81M02(6,1:Index81M02(6))-Tpulmao81M02(4,1)];
    P81M02 = [Ppulmao81M02(4,1:Index81M02(4)) Ppulmao81M02(5,1:Index81M02(5)) Ppulmao81M02(6,1:Index81M02(6))];
    T81M03 = [Tpulmao81M03(4,1:Index81M03(4))-Tpulmao81M03(4,1) Tpulmao81M03(5,1:Index81M03(5))-Tpulmao81M03(4,1) Tpulmao81M03(6,1:Index81M03(6))-Tpulmao81M03(4,1)];
    P81M03 = [Ppulmao81M03(4,1:Index81M03(4)) Ppulmao81M03(5,1:Index81M03(5)) Ppulmao81M03(6,1:Index81M03(6))];
    
    
    %Criação dos timestamp para sincronização
    P70601 = timetable(T70601',P70601','VariableNames',{'Pressure'});
    P70602 = timetable(T70602',P70602','VariableNames',{'Pressure'});
    P70603 = timetable(T70603',P70603','VariableNames',{'Pressure'});
    P70801 = timetable(T70801',P70801','VariableNames',{'Pressure'});
    P70802 = timetable(T70802',P70802','VariableNames',{'Pressure'});
    P70803 = timetable(T70803',P70803','VariableNames',{'Pressure'});
    P71001 = timetable(T71001',P71001','VariableNames',{'Pressure'});
    P71002 = timetable(T71002',P71002','VariableNames',{'Pressure'});
    P71003 = timetable(T71003',P71003','VariableNames',{'Pressure'});
    P80601 = timetable(T80601',P80601','VariableNames',{'Pressure'});
    P80602 = timetable(T80602',P80602','VariableNames',{'Pressure'});
    P80603 = timetable(T80603',P80603','VariableNames',{'Pressure'});
    P80801 = timetable(T80801',P80801','VariableNames',{'Pressure'});
    P80802 = timetable(T80802',P80802','VariableNames',{'Pressure'});
    P80803 = timetable(T80803',P80803','VariableNames',{'Pressure'});
    P81001 = timetable(T81001',P81001','VariableNames',{'Pressure'});
    P81002 = timetable(T81002',P81002','VariableNames',{'Pressure'});
    P81003 = timetable(T81003',P81003','VariableNames',{'Pressure'});
    P81E01 = timetable(T81E01',P81E01','VariableNames',{'Pressure'});
    P81E02 = timetable(T81E02',P81E02','VariableNames',{'Pressure'});
    P81E03 = timetable(T81E03',P81E03','VariableNames',{'Pressure'});
    P81M01 = timetable(T81M01',P81M01','VariableNames',{'Pressure'});
    P81M02 = timetable(T81M02',P81M02','VariableNames',{'Pressure'});
    P81M03 = timetable(T81M03',P81M03','VariableNames',{'Pressure'});
    
    %Montagem dos grupos de dados
    P706 = synchronize(P70601,P70602,P70603,'union','previous');
    P708 = synchronize(P70801,P70802,P70803,'union','previous');
    P710 = synchronize(P71001,P71002,P71003,'union','previous');
    P806 = synchronize(P80601,P80602,P80603,'union','previous');
    P808 = synchronize(P80801,P80802,P80803,'union','previous');
    P810 = synchronize(P81001,P81002,P81003,'union','previous');
    P812 = synchronize(P81E01,P81E02,P81E03,P81M01,P81M02,P81M03,'union','previous');
    
    % % % %Para testar
    % % % P812 = synchronize(P81M01,P81M02,P81M03,'union','previous');
    
    % figure (1)
    % plot (P710.Time,P710.Pressure_P71001,'b',P710.Time,P710.Pressure_P71002,'r',P710.Time,P710.Pressure_P71003,'g')
    % legend('1','2','3','Location','Best')
    % xlabel('Time')
    % ylabel('Pressure [cmH2O]')
    
    %% Configurando a simulação
    %Tempo da Simulação (seg) - Tempo total da simulação no simulink
    Tsimulacao = 5+15+20+15+20+15+5;
    %Tempo de amostragem (seg) - Tempo para cada calculo do simulink
    Tamostra = 0.001;
    %Pressão do Ventilador (cm H20)
    Pvent = 5+Indice_PEEP*5; %Pvent ideal
    
    %Calculo da pressão de aspiração
    Pasp = [mean([PmedAsp70601(4) PmedAsp70602(4) PmedAsp70603(4)]), mean([PmedAsp70601(5) PmedAsp70602(5) PmedAsp70603(5)]), mean([PmedAsp70601(6) PmedAsp70602(6) PmedAsp70603(6)]);
        mean([PmedAsp70801(4) PmedAsp70802(4) PmedAsp70803(4)]), mean([PmedAsp70801(5) PmedAsp70802(5) PmedAsp70803(5)]), mean([PmedAsp70801(6) PmedAsp70802(6) PmedAsp70803(6)]);
        mean([PmedAsp71001(4) PmedAsp71002(4) PmedAsp71003(4)]), mean([PmedAsp71001(5) PmedAsp71002(5) PmedAsp71003(5)]), mean([PmedAsp71001(6) PmedAsp71002(6) PmedAsp71003(6)]);
        mean([PmedAsp80601(4) PmedAsp80602(4) PmedAsp80603(4)]), mean([PmedAsp80601(5) PmedAsp80602(5) PmedAsp80603(5)]), mean([PmedAsp80601(6) PmedAsp80602(6) PmedAsp80603(6)]);
        mean([PmedAsp80801(4) PmedAsp80802(4) PmedAsp80803(4)]), mean([PmedAsp80801(5) PmedAsp80802(5) PmedAsp80803(5)]), mean([PmedAsp80801(6) PmedAsp80802(6) PmedAsp80803(6)]);
        mean([PmedAsp81001(4) PmedAsp81002(4) PmedAsp81003(4)]), mean([PmedAsp81001(5) PmedAsp81002(5) PmedAsp81003(5)]), mean([PmedAsp81001(6) PmedAsp81002(6) PmedAsp81003(6)]);
        mean([PmedAsp81E01(4) PmedAsp81E02(4) PmedAsp81E03(4) PmedAsp81M01(4) PmedAsp81M02(4) PmedAsp81M03(4)]), mean([PmedAsp81E01(5) PmedAsp81E02(5) PmedAsp81E03(5) PmedAsp81M01(5) PmedAsp81M02(5) PmedAsp81M03(5)]), mean([PmedAsp81E01(6) PmedAsp81E02(6) PmedAsp81E03(6) PmedAsp81M01(6) PmedAsp81M02(6) PmedAsp81M03(6)])];
    
    % % % %Para testar
    % % % Pasp = [mean([Pasp81M01(4) Pasp81M02(4) Pasp81M03(4)]), mean([Pasp81M01(5) Pasp81M02(5) Pasp81M03(5)]), mean([Pasp81M01(6) Pasp81M02(6) Pasp81M03(6)])];
    
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
    
    %% Simulação
    
    for TOT=1:2
        if TOT == 1
            %TOT 7.5
            for SONDA=1:3
                %Sondas 06, 08, 10
                if SONDA == 1
                    %Sondas 06
                    TOT = 7.5;
                    Tamanho_Sonda = 06;
                    PaspMin = Pasp(1,1);
                    PaspMed = Pasp(1,2);
                    PaspMax = Pasp(1,3);
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim706=PressaoSimulada;
                    
                elseif SONDA == 2
                    %Sondas 08
                    TOT = 7.5;
                    Tamanho_Sonda = 08;
                    PaspMin = Pasp(2,1);
                    PaspMed = Pasp(2,2);
                    PaspMax = Pasp(2,3);
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim708=PressaoSimulada;
                    
                elseif SONDA == 3
                    %Sondas 10
                    TOT = 7.5;
                    Tamanho_Sonda = 10;
                    PaspMin = Pasp(3,1);
                    PaspMed = Pasp(3,2);
                    PaspMax = Pasp(3,3);
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim710=PressaoSimulada;
                    
                end
            end
        elseif TOT == 2
            %TOT 8.5
            for SONDA=1:4
                %Sondas 06, 08, 10, 12
                if SONDA == 1
                    %Sondas 06
                    TOT = 8.5;
                    Tamanho_Sonda = 06;
                    PaspMin = Pasp(4,1);
                    PaspMed = Pasp(4,2);
                    PaspMax = Pasp(4,3);
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim806=PressaoSimulada;
                    
                elseif SONDA == 2
                    %Sondas 08
                    TOT = 8.5;
                    Tamanho_Sonda = 08;
                    PaspMin = Pasp(5,1);
                    PaspMed = Pasp(5,2);
                    PaspMax = Pasp(5,3);
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim808=PressaoSimulada;
                    
                elseif SONDA == 3
                    %Sondas 10
                    TOT = 8.5;
                    Tamanho_Sonda = 10;
                    PaspMin = Pasp(6,1);
                    PaspMed = Pasp(6,2);
                    PaspMax = Pasp(6,3);
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim810=PressaoSimulada;
                    
                elseif SONDA == 4
                    %Sondas 12
                    TOT = 8.5;
                    Tamanho_Sonda = 12;
                    PaspMin = Pasp(7,1);
                    PaspMed = Pasp(7,2);
                    PaspMax = Pasp(7,3);
                    
                    % % % % %                 %Para testar
                    % % % % %                 PaspMin = Pasp(1,1);
                    % % % % %                 PaspMed = Pasp(1,2);
                    % % % % %                 PaspMax = Pasp(1,3);
                    
                    sim('ModeloControlePorPressaoRevFinal_Validacao')
                    Psim812=PressaoSimulada;
                    
                end
            end
        end
    end
    
    
    %% Comparação dos sinais
    
    % % %Plots dos sinais
    % % figure (1)
    % % plot (P706.Time,P706.Pressure_P70601,'b',P706.Time,P706.Pressure_P70602,'r',P706.Time,P706.Pressure_P70603,'g')
    % % legend('E001','E002','E003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim706.Time),Psim706.Data,'k')
    % % legend('E001','E002','E003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 7.5 Sonda 06FR')
    % %
    % % figure (2)
    % % plot (P708.Time,P708.Pressure_P70801,'b',P708.Time,P708.Pressure_P70802,'r',P708.Time,P708.Pressure_P70803,'g')
    % % legend('E001','E002','E003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim708.Time),Psim708.Data,'k')
    % % legend('E001','E002','E003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 7.5 Sonda 08FR')
    % %
    % % figure (3)
    % % plot (P710.Time,P710.Pressure_P71001,'b',P710.Time,P710.Pressure_P71002,'r',P710.Time,P710.Pressure_P71003,'g')
    % % legend('M001','M002','M003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim710.Time),Psim710.Data,'k')
    % % legend('M001','M002','M003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 7.5 Sonda 10FR')
    % %
    % % figure (4)
    % % plot (P806.Time,P806.Pressure_P80601,'b',P806.Time,P806.Pressure_P80602,'r',P806.Time,P806.Pressure_P80603,'g')
    % % legend('E001','E002','E003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim806.Time),Psim806.Data,'k')
    % % legend('E001','E002','E003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 8.5 Sonda 06FR')
    % %
    % % figure (5)
    % % plot (P808.Time,P808.Pressure_P80801,'b',P808.Time,P808.Pressure_P80802,'r',P808.Time,P808.Pressure_P80803,'g')
    % % legend('E001','E002','E003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim808.Time),Psim808.Data,'k')
    % % legend('E001','E002','E003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 8.5 Sonda 08FR')
    % %
    % % figure (6)
    % % plot (P810.Time,P810.Pressure_P81001,'b',P810.Time,P810.Pressure_P81002,'r',P810.Time,P810.Pressure_P81003,'g')
    % % legend('M001','M002','M003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim810.Time),Psim810.Data,'k')
    % % legend('M001','M002','M003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 8.5 Sonda 10FR')
    % %
    % % figure (7)
    % % plot (P812.Time,P812.Pressure_P81E01,'b',P812.Time,P812.Pressure_P81E02,'r',P812.Time,P812.Pressure_P81E03,'g',P812.Time,P812.Pressure_P81M01,'b--',P812.Time,P812.Pressure_P81M02,'r--',P812.Time,P812.Pressure_P81M03,'g--')
    % % legend('E001','E002','E003','M001','M002','M003','Location','Best')
    % % xlabel('Time')
    % % ylabel('Pressure [cmH2O]')
    % %
    % % hold on
    % % plot(seconds(Psim812.Time),Psim812.Data,'k')
    % % legend('E001','E002','E003','M001','M002','M003','Simulation','Location','Best')
    % % hold off
    % % title('TOT 8.5 Sonda 12FR')
    
    % %Calculo das médias e desvio padrão das vazão do ventilador sem aspiração
    % Medias_Std = [mean([Vvent70601 Vvent70602 Vvent70603]), std([Vvent70601 Vvent70602 Vvent70603]);
    %     mean([Vvent70801 Vvent70802 Vvent70803]), std([Vvent70801 Vvent70802 Vvent70803])
    %     mean([Vvent71001 Vvent71002 Vvent71003]), std([Vvent71001 Vvent71002 Vvent71003])
    %     mean([Vvent80601 Vvent80602 Vvent80603]), std([Vvent80601 Vvent80602 Vvent80603])
    %     mean([Vvent80801 Vvent80802 Vvent80803]), std([Vvent80801 Vvent80802 Vvent80803])
    %     mean([Vvent81001 Vvent81002 Vvent81003]), std([Vvent81001 Vvent81002 Vvent81003])
    %     mean([Vvent81E01 Vvent81E02 Vvent81E03 Vvent81M01 Vvent81M02 Vvent81M03]), std([Vvent81E01 Vvent81E02 Vvent81E03 Vvent81M01 Vvent81M02 Vvent81M03])];
    
    % % % %Para Teste
    % % % Medias_Std = [mean([Vvent81M01 Vvent81M02 Vvent81M03]) std([Vvent81M01 Vvent81M02 Vvent81M03])];
    
    % %Calculo das diferenças de pressões médias durante a aspiração
    PmedVent = [mean([PmedVent70601(4) PmedVent70602(4) PmedVent70603(4)]), mean([PmedVent70601(5) PmedVent70602(5) PmedVent70603(5)]), mean([PmedVent70601(6) PmedVent70602(6) PmedVent70603(6)]);
        mean([PmedVent70801(4) PmedVent70802(4) PmedVent70803(4)]), mean([PmedVent70801(5) PmedVent70802(5) PmedVent70803(5)]), mean([PmedVent70801(6) PmedVent70802(6) PmedVent70803(6)]);
        mean([PmedVent71001(4) PmedVent71002(4) PmedVent71003(4)]), mean([PmedVent71001(5) PmedVent71002(5) PmedVent71003(5)]), mean([PmedVent71001(6) PmedVent71002(6) PmedVent71003(6)]);
        mean([PmedVent80601(4) PmedVent80602(4) PmedVent80603(4)]), mean([PmedVent80601(5) PmedVent80602(5) PmedVent80603(5)]), mean([PmedVent80601(6) PmedVent80602(6) PmedVent80603(6)]);
        mean([PmedVent80801(4) PmedVent80802(4) PmedVent80803(4)]), mean([PmedVent80801(5) PmedVent80802(5) PmedVent80803(5)]), mean([PmedVent80801(6) PmedVent80802(6) PmedVent80803(6)]);
        mean([PmedVent81001(4) PmedVent81002(4) PmedVent81003(4)]), mean([PmedVent81001(5) PmedVent81002(5) PmedVent81003(5)]), mean([PmedVent81001(6) PmedVent81002(6) PmedVent81003(6)]);
        mean([PmedVent81E01(4) PmedVent81E02(4) PmedVent81E03(4) PmedVent81M01(4) PmedVent81M02(4) PmedVent81M03(4)]), mean([PmedVent81E01(5) PmedVent81E02(5) PmedVent81E03(5) PmedVent81M01(5) PmedVent81M02(5) PmedVent81M03(5)]), mean([PmedVent81E01(6) PmedVent81E02(6) PmedVent81E03(6) PmedVent81M01(6) PmedVent81M02(6) PmedVent81M03(6)])];
    
    PmedPulmao = [mean([PmedPulmao70601(4) PmedPulmao70602(4) PmedPulmao70603(4)]), mean([PmedPulmao70601(5) PmedPulmao70602(5) PmedPulmao70603(5)]), mean([PmedPulmao70601(6) PmedPulmao70602(6) PmedPulmao70603(6)]);
        mean([PmedPulmao70801(4) PmedPulmao70802(4) PmedPulmao70803(4)]), mean([PmedPulmao70801(5) PmedPulmao70802(5) PmedPulmao70803(5)]), mean([PmedPulmao70801(6) PmedPulmao70802(6) PmedPulmao70803(6)]);
        mean([PmedPulmao71001(4) PmedPulmao71002(4) PmedPulmao71003(4)]), mean([PmedPulmao71001(5) PmedPulmao71002(5) PmedPulmao71003(5)]), mean([PmedPulmao71001(6) PmedPulmao71002(6) PmedPulmao71003(6)]);
        mean([PmedPulmao80601(4) PmedPulmao80602(4) PmedPulmao80603(4)]), mean([PmedPulmao80601(5) PmedPulmao80602(5) PmedPulmao80603(5)]), mean([PmedPulmao80601(6) PmedPulmao80602(6) PmedPulmao80603(6)]);
        mean([PmedPulmao80801(4) PmedPulmao80802(4) PmedPulmao80803(4)]), mean([PmedPulmao80801(5) PmedPulmao80802(5) PmedPulmao80803(5)]), mean([PmedPulmao80801(6) PmedPulmao80802(6) PmedPulmao80803(6)]);
        mean([PmedPulmao81001(4) PmedPulmao81002(4) PmedPulmao81003(4)]), mean([PmedPulmao81001(5) PmedPulmao81002(5) PmedPulmao81003(5)]), mean([PmedPulmao81001(6) PmedPulmao81002(6) PmedPulmao81003(6)]);
        mean([PmedPulmao81E01(4) PmedPulmao81E02(4) PmedPulmao81E03(4) PmedPulmao81M01(4) PmedPulmao81M02(4) PmedPulmao81M03(4)]), mean([PmedPulmao81E01(5) PmedPulmao81E02(5) PmedPulmao81E03(5) PmedPulmao81M01(5) PmedPulmao81M02(5) PmedPulmao81M03(5)]), mean([PmedPulmao81E01(6) PmedPulmao81E02(6) PmedPulmao81E03(6) PmedPulmao81M01(6) PmedPulmao81M02(6) PmedPulmao81M03(6)])];
    
    PsimPulmao = [Psim706.Data(12501), Psim706.Data(47501), Psim706.Data(82501);
        Psim708.Data(12501), Psim708.Data(47501), Psim708.Data(82501);
        Psim710.Data(12501), Psim710.Data(47501), Psim710.Data(82501);
        Psim806.Data(12501), Psim806.Data(47501), Psim806.Data(82501);
        Psim808.Data(12501), Psim808.Data(47501), Psim808.Data(82501);
        Psim810.Data(12501), Psim810.Data(47501), Psim810.Data(82501);
        Psim812.Data(12501), Psim812.Data(47501), Psim812.Data(82501)];
    
    DifPVentPulmao = PmedVent - PmedPulmao;%Diferença entre a pressão media de ventilação com o do pulmao
    DifPPulmaoSim = PmedPulmao - PsimPulmao;%Diferença entre a pressão experimental e pressão simulada
    DifVentSimDifPsim = 10*ones(size(PsimPulmao)) - PsimPulmao;%Diferença entre a pressão simulada do ventilador com a pressão simulada alveolar
    
    %% Fazendo a correlação dos sinais
    
    %%Para a função CorrelacaoInd
    Corr706 = zeros(1,4);
    [Corr706(1,1), Corr706(1,2), Corr706(1,3), Corr706(1,4)]= CorrelacaoInd(Psim706,P706);
    Corr708 = zeros(1,4);
    [Corr708(1,1), Corr708(1,2), Corr708(1,3), Corr708(1,4)]= CorrelacaoInd(Psim708,P708);
    Corr710 = zeros(1,4);
    [Corr710(1,1), Corr710(1,2), Corr710(1,3), Corr710(1,4)]= CorrelacaoInd(Psim710,P710);
    Corr806 = zeros(1,4);
    [Corr806(1,1), Corr806(1,2), Corr806(1,3), Corr806(1,4)]= CorrelacaoInd(Psim806,P806);
    Corr808 = zeros(1,4);
    [Corr808(1,1), Corr808(1,2), Corr808(1,3), Corr808(1,4)]= CorrelacaoInd(Psim808,P808);
    Corr810 = zeros(1,4);
    [Corr810(1,1), Corr810(1,2), Corr810(1,3), Corr810(1,4)]= CorrelacaoInd(Psim810,P810);
    Corr812 = zeros(1,7);
    [Corr812(1,1), Corr812(1,2), Corr812(1,3), Corr812(1,4) Corr812(1,5) Corr812(1,6) Corr812(1,7)]= CorrelacaoInd(Psim812,P812);
    
    
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
    
    
    
    %% Plot dos dados cortados
    % % % % plot(P706.Time,P706.Pressure_P70601,'b',P706.Time,P706.Pressure_P70602,'r',P706.Time,P706.Pressure_P70603,'g',seconds(Psim706.Time),Psim706.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 7.5 Sonda 06')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Simulação')
    % % % %
    % % % % plot(P708.Time,P708.Pressure_P70801,'b',P708.Time,P708.Pressure_P70802,'r',P708.Time,P708.Pressure_P70803,'g',seconds(Psim708.Time),Psim708.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 7.5 Sonda 08')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Simulação')
    % % % %
    % % % % plot(P710.Time,P710.Pressure_P71001,'b',P710.Time,P710.Pressure_P71002,'r',P710.Time,P710.Pressure_P71003,'g',seconds(Psim710.Time),Psim710.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 7.5 Sonda 10')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Simulação')
    % % % %
    % % % % plot(P806.Time,P806.Pressure_P80601,'b',P806.Time,P806.Pressure_P80602,'r',P806.Time,P806.Pressure_P80603,'g',seconds(Psim806.Time),Psim806.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 8.5 Sonda 06')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Simulação')
    % % % %
    % % % % plot(P808.Time,P808.Pressure_P80801,'b',P808.Time,P808.Pressure_P80802,'r',P808.Time,P808.Pressure_P80803,'g',seconds(Psim808.Time),Psim808.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 8.5 Sonda 08')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Simulação')
    % % % %
    % % % % plot(P810.Time,P810.Pressure_P81001,'b',P810.Time,P810.Pressure_P81002,'r',P810.Time,P810.Pressure_P81003,'g',seconds(Psim810.Time),Psim810.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 8.5 Sonda 10')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Simulação')
    % % % %
    % % % % plot(P812.Time,P812.Pressure_P81E01,'b',P812.Time,P812.Pressure_P81E02,'r',P812.Time,P812.Pressure_P81E03,'g',P812.Time,P812.Pressure_P81M01,'b--',P812.Time,P812.Pressure_P81M02,'r--',P812.Time,P812.Pressure_P81M03,'g--',seconds(Psim812.Time),Psim812.Data,'k')
    % % % % xlabel ('Time [s]')
    % % % % ylabel ('Pressure [cmH2O]')
    % % % % title('TOT 8.5 Sonda 12')
    % % % % legend('Sonda 01','Sonda 02','Sonda 03','Sonda 04','Sonda 05','Sonda 06','Simulação')

end