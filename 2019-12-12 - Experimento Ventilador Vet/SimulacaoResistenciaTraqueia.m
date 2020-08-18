%Faz a simulação e a comparação dos dados do modelo fisico e digital

clc
clear all
close all


%% Leitura dos Dados

%Codigo do Nome -> _ (TOT - 7,8) _ _ (sonda - 06,08,10) _ _ (numero - 01,02,03)
%TOT 7.5
%Sondas 06
[P761, Tpulmao70601, Ppulmao70601, Index70601, PmedAsp70601, PmedVent70601, PmedPulmao70601,VmedVent70601,Pvent70601,Pasp70601] = Leitura('E06FR001_TOT7.5_Vet.txt');
[P762, Tpulmao70602, Ppulmao70602, Index70602, PmedAsp70602, PmedVent70602, PmedPulmao70602,VmedVent70602,Pvent70602,Pasp70602] = Leitura('E06FR002_TOT7.5_Vet.txt');
[P763, Tpulmao70603, Ppulmao70603, Index70603, PmedAsp70603, PmedVent70603, PmedPulmao70603,VmedVent70603,Pvent70603,Pasp70603] = Leitura('E06FR003_TOT7.5_Vet.txt');
%Sondas 08
[P781, Tpulmao70801, Ppulmao70801, Index70801, PmedAsp70801, PmedVent70801, PmedPulmao70801,VmedVent70801,Pvent70801,Pasp70801] = Leitura('E08FR001_TOT7.5_Vet.txt');
[P782, Tpulmao70802, Ppulmao70802, Index70802, PmedAsp70802, PmedVent70802, PmedPulmao70802,VmedVent70802,Pvent70802,Pasp70802] = Leitura('E08FR002_TOT7.5_Vet.txt');
[P783, Tpulmao70803, Ppulmao70803, Index70803, PmedAsp70803, PmedVent70803, PmedPulmao70803,VmedVent70803,Pvent70803,Pasp70803] = Leitura('E08FR003_TOT7.5_Vet.txt');
%Sondas 10
[P711, Tpulmao71001, Ppulmao71001, Index71001, PmedAsp71001, PmedVent71001, PmedPulmao71001,VmedVent71001,Pvent71001,Pasp71001] = Leitura('M10FR001_TOT7.5_Vet.txt');
[P712, Tpulmao71002, Ppulmao71002, Index71002, PmedAsp71002, PmedVent71002, PmedPulmao71002,VmedVent71002,Pvent71002,Pasp71002] = Leitura('M10FR002_TOT7.5_Vet.txt');
[P713, Tpulmao71003, Ppulmao71003, Index71003, PmedAsp71003, PmedVent71003, PmedPulmao71003,VmedVent71003,Pvent71003,Pasp71003] = Leitura('M10FR003_TOT7.5_Vet.txt');
%TOT 8.5
%Sondas 06, 08, 10, E12, M12
%Sondas 06
[P861, Tpulmao80601, Ppulmao80601, Index80601, PmedAsp80601, PmedVent80601, PmedPulmao80601,VmedVent80601,Pvent80601,Pasp80601] = Leitura('E06FR001_TOT8.5_Vet.txt');
[P862, Tpulmao80602, Ppulmao80602, Index80602, PmedAsp80602, PmedVent80602, PmedPulmao80602,VmedVent80602,Pvent80602,Pasp80602] = Leitura('E06FR002_TOT8.5_Vet.txt');
[P863, Tpulmao80603, Ppulmao80603, Index80603, PmedAsp80603, PmedVent80603, PmedPulmao80603,VmedVent80603,Pvent80603,Pasp80603] = Leitura('E06FR003_TOT8.5_Vet.txt');
%Sondas 08
[P881, Tpulmao80801, Ppulmao80801, Index80801, PmedAsp80801, PmedVent80801, PmedPulmao80801,VmedVent80801,Pvent80801,Pasp80801] = Leitura('E08FR001_TOT8.5_Vet.txt');
[P882, Tpulmao80802, Ppulmao80802, Index80802, PmedAsp80802, PmedVent80802, PmedPulmao80802,VmedVent80802,Pvent80802,Pasp80802] = Leitura('E08FR002_TOT8.5_Vet.txt');
[P883, Tpulmao80803, Ppulmao80803, Index80803, PmedAsp80803, PmedVent80803, PmedPulmao80803,VmedVent80803,Pvent80803,Pasp80803] = Leitura('E08FR003_TOT8.5_Vet.txt');
%Sondas 10
[P8101, Tpulmao81001, Ppulmao81001, Index81001, PmedAsp81001, PmedVent81001, PmedPulmao81001,VmedVent81001,Pvent81001,Pasp81001] = Leitura('M10FR001_TOT8.5_Vet.txt');
[P8102, Tpulmao81002, Ppulmao81002, Index81002, PmedAsp81002, PmedVent81002, PmedPulmao81002,VmedVent81002,Pvent81002,Pasp81002] = Leitura('M10FR002_TOT8.5_Vet.txt');
[P8103, Tpulmao81003, Ppulmao81003, Index81003, PmedAsp81003, PmedVent81003, PmedPulmao81003,VmedVent81003,Pvent81003,Pasp81003] = Leitura('M10FR003_TOT8.5_Vet.txt');
%Sondas E12
[P8E1, Tpulmao81E01, Ppulmao81E01, Index81E01, PmedAsp81E01, PmedVent81E01, PmedPulmao81E01,VmedVent81E01,Pvent81E01,Pasp81E01] = Leitura('E12FR001_TOT8.5_Vet.txt');
[P8E2, Tpulmao81E02, Ppulmao81E02, Index81E02, PmedAsp81E02, PmedVent81E02, PmedPulmao81E02,VmedVent81E02,Pvent81E02,Pasp81E02] = Leitura('E12FR002_TOT8.5_Vet.txt');
[P8E3, Tpulmao81E03, Ppulmao81E03, Index81E03, PmedAsp81E03, PmedVent81E03, PmedPulmao81E03,VmedVent81E03,Pvent81E03,Pasp81E03] = Leitura('E12FR003_TOT8.5_Vet.txt');
%Sondas M12
[P8M1, Tpulmao81M01, Ppulmao81M01, Index81M01, PmedAsp81M01, PmedVent81M01, PmedPulmao81M01,VmedVent81M01,Pvent81M01,Pasp81M01] = Leitura('M12FR001_TOT8.5_Vet.txt');
[P8M2, Tpulmao81M02, Ppulmao81M02, Index81M02, PmedAsp81M02, PmedVent81M02, PmedPulmao81M02,VmedVent81M02,Pvent81M02,Pasp81M02] = Leitura('M12FR002_TOT8.5_Vet.txt');
[P8M3, Tpulmao81M03, Ppulmao81M03, Index81M03, PmedAsp81M03, PmedVent81M03, PmedPulmao81M03,VmedVent81M03,Pvent81M03,Pasp81M03] = Leitura('M12FR003_TOT8.5_Vet.txt');


%% Plots considerando resistência
PressaoRef = [5 5 5 10 10 10 15 15 15]';
% % % % % plot(VmedVent70601,PressaoRef - PmedVent70601,'bo')
% % % % % hold on
% % % % % plot(VmedVent70801,PressaoRef - PmedVent70801,'ro')
% % % % % plot(VmedVent71001,PressaoRef - PmedVent71001,'go')
% % % % % plot(VmedVent80601,PressaoRef - PmedVent80601,'b+')
% % % % % plot(VmedVent80801,PressaoRef - PmedVent80801,'r+')
% % % % % plot(VmedVent81001,PressaoRef - PmedVent81001,'g+')
% % % % % plot(VmedVent81E01,PressaoRef - PmedVent81E01,'k+')
% % % % % 
% % % % % plot(VmedVent70602,PressaoRef - PmedVent70602,'bo')
% % % % % plot(VmedVent70603,PressaoRef - PmedVent70603,'bo')
% % % % % plot(VmedVent70802,PressaoRef - PmedVent70802,'ro')
% % % % % plot(VmedVent70803,PressaoRef - PmedVent70803,'ro')
% % % % % plot(VmedVent71002,PressaoRef - PmedVent71002,'go')
% % % % % plot(VmedVent71003,PressaoRef - PmedVent71003,'go')
% % % % % plot(VmedVent80602,PressaoRef - PmedVent80602,'b+')
% % % % % plot(VmedVent80603,PressaoRef - PmedVent80603,'b+')
% % % % % plot(VmedVent80802,PressaoRef - PmedVent80802,'r+')
% % % % % plot(VmedVent80803,PressaoRef - PmedVent80803,'r+')
% % % % % plot(VmedVent81002,PressaoRef - PmedVent81002,'g+')
% % % % % plot(VmedVent81003,PressaoRef - PmedVent81003,'g+')
% % % % % plot(VmedVent81E02,PressaoRef - PmedVent81E02,'k+')
% % % % % plot(VmedVent81E03,PressaoRef - PmedVent81E03,'k+')
% % % % % plot(VmedVent81M01,PressaoRef - PmedVent81M01,'k+')
% % % % % plot(VmedVent81M02,PressaoRef - PmedVent81M02,'k+')
% % % % % plot(VmedVent81M03,PressaoRef - PmedVent81M03,'k+')
% % % % % hold off
% % % % % xlabel('Flow [L/s]')
% % % % % ylabel('Pressure Set - Pressure Ventilation [cmH2O]')
% % % % % legend('TOT 7.5 Sonda 06','TOT 7.5 Sonda 08','TOT 7.5 Sonda 10','TOT 8.5 Sonda 06','TOT 8.5 Sonda 08','TOT 8.5 Sonda 10','TOT 8.5 Sonda 12','location','Northwest')
% % % % % title({'Grafico de Pressão x Vazão','Para calculo de resistência da traqueia do ventilador'})
% % % % % 
X = [(PressaoRef-PmedVent70601)' (PressaoRef-PmedVent70602)' (PressaoRef-PmedVent70603)' (PressaoRef-PmedVent70801)' (PressaoRef-PmedVent70802)' (PressaoRef-PmedVent70803)' (PressaoRef-PmedVent71001)' (PressaoRef-PmedVent71002)' (PressaoRef-PmedVent71003)'  (PressaoRef-PmedVent80601)' (PressaoRef-PmedVent80602)' (PressaoRef-PmedVent80603)'  (PressaoRef-PmedVent80801)' (PressaoRef-PmedVent80802)' (PressaoRef-PmedVent80803)'  (PressaoRef-PmedVent81001)' (PressaoRef-PmedVent81002)' (PressaoRef-PmedVent81003)'  (PressaoRef-PmedVent81E01)' (PressaoRef-PmedVent81E02)' (PressaoRef-PmedVent81E03)'  (PressaoRef-PmedVent81M01)' (PressaoRef-PmedVent81M02)' (PressaoRef-PmedVent81M03)'];
Y = [VmedVent70601 VmedVent70602 VmedVent70603 VmedVent70801 VmedVent70802 VmedVent70803 VmedVent71001 VmedVent71002 VmedVent71003 VmedVent80601 VmedVent80602 VmedVent80603 VmedVent80801 VmedVent80802 VmedVent80803 VmedVent81001 VmedVent81002 VmedVent81003 VmedVent81E01 VmedVent81E02 VmedVent81E03 VmedVent81M01 VmedVent81M02 VmedVent81M03];
% % figure
% % scatter(X,Y)
% % ylabel('Flow [L/s]')
% % xlabel('Pressure Set - Pressure Ventilation [cmH2O]')
% % title({'Grafico de Vazão x Pressão','Para calculo de resistência da traqueia do ventilador pelo cftool'})


%Utilizando o cftool
%Eq V' = a*P^b -> a = 0.06857 e b = 0.3014
%Eq P = a*V'^2+b*V' -> a = 81.53 e b = 13.93
P = 0:0.01:3;
V = 0.06857 *P.^0.3014;
figure
scatter(X,Y)
hold on
plot(P,V)
hold off
ylabel('Flow [L/s]')
xlabel('Pressure Set - Pressure Ventilation [cmH2O]')
title({'Grafico de Vazão x Pressão','Para calculo de resistência da traqueia do ventilador pelo cftool'})

%% Plots considerando pertubação da entrada Pasp na entrada Pvent

%Calculo do Pvent e Pasp antes de ligar o aspirador
PmedVentAnterior70601 = zeros(size(PmedVent70601));
PmedAspAnterior70601 = zeros(size(PmedAsp70601));
PmedVentAnterior70602 = zeros(size(PmedVent70602));
PmedAspAnterior70602 = zeros(size(PmedAsp70602));
PmedVentAnterior70603 = zeros(size(PmedVent70603));
PmedAspAnterior70603 = zeros(size(PmedAsp70603));

PmedVentAnterior70801 = zeros(size(PmedVent70801));
PmedAspAnterior70801 = zeros(size(PmedAsp70801));
PmedVentAnterior70802 = zeros(size(PmedVent70802));
PmedAspAnterior70802 = zeros(size(PmedAsp70802));
PmedVentAnterior70803 = zeros(size(PmedVent70803));
PmedAspAnterior70803 = zeros(size(PmedAsp70803));

PmedVentAnterior71001 = zeros(size(PmedVent71001));
PmedAspAnterior71001 = zeros(size(PmedAsp71001));
PmedVentAnterior71002 = zeros(size(PmedVent71002));
PmedAspAnterior71002 = zeros(size(PmedAsp71002));
PmedVentAnterior71003 = zeros(size(PmedVent71003));
PmedAspAnterior71003 = zeros(size(PmedAsp71003));

PmedVentAnterior80601 = zeros(size(PmedVent80601));
PmedAspAnterior80601 = zeros(size(PmedAsp80601));
PmedVentAnterior80602 = zeros(size(PmedVent80602));
PmedAspAnterior80602 = zeros(size(PmedAsp80602));
PmedVentAnterior80603 = zeros(size(PmedVent80603));
PmedAspAnterior80603 = zeros(size(PmedAsp80603));

PmedVentAnterior80801 = zeros(size(PmedVent80801));
PmedAspAnterior80801 = zeros(size(PmedAsp80801));
PmedVentAnterior80802 = zeros(size(PmedVent80802));
PmedAspAnterior80802 = zeros(size(PmedAsp80802));
PmedVentAnterior80803 = zeros(size(PmedVent80803));
PmedAspAnterior80803 = zeros(size(PmedAsp80803));

PmedVentAnterior81001 = zeros(size(PmedVent81001));
PmedAspAnterior81001 = zeros(size(PmedAsp81001));
PmedVentAnterior81002 = zeros(size(PmedVent81002));
PmedAspAnterior81002 = zeros(size(PmedAsp81002));
PmedVentAnterior81003 = zeros(size(PmedVent81003));
PmedAspAnterior81003 = zeros(size(PmedAsp81003));

PmedVentAnterior81E01 = zeros(size(PmedVent81E01));
PmedAspAnterior81E01 = zeros(size(PmedAsp81E01));
PmedVentAnterior81E02 = zeros(size(PmedVent81E02));
PmedAspAnterior81E02 = zeros(size(PmedAsp81E02));
PmedVentAnterior81E03 = zeros(size(PmedVent81E03));
PmedAspAnterior81E03 = zeros(size(PmedAsp81E03));

PmedVentAnterior81M01 = zeros(size(PmedVent81M01));
PmedAspAnterior81M01 = zeros(size(PmedAsp81M01));
PmedVentAnterior81M02 = zeros(size(PmedVent81M02));
PmedAspAnterior81M02 = zeros(size(PmedAsp81M02));
PmedVentAnterior81M03 = zeros(size(PmedVent81M03));
PmedAspAnterior81M03 = zeros(size(PmedAsp81M03));

for i=1:9
    j=1;
    while Tpulmao70601(i,j)<=Tpulmao70601(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior70601(i)=mean(Pasp70601(i,1:j));
    PmedVentAnterior70601(i)=mean(Pvent70601(i,1:j));
    
    j=1;
    while Tpulmao70602(i,j)<=Tpulmao70602(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior70602(i)=mean(Pasp70602(i,1:j));
    PmedVentAnterior70602(i)=mean(Pvent70602(i,1:j));
    
    j=1;
    while Tpulmao70603(i,j)<=Tpulmao70603(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior70603(i)=mean(Pasp70603(i,1:j));
    PmedVentAnterior70603(i)=mean(Pvent70603(i,1:j));
    
    
    j=1;
    while Tpulmao70801(i,j)<=Tpulmao70801(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior70801(i)=mean(Pasp70801(i,1:j));
    PmedVentAnterior70801(i)=mean(Pvent70801(i,1:j));
    
    j=1;
    while Tpulmao70802(i,j)<=Tpulmao70802(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior70802(i)=mean(Pasp70802(i,1:j));
    PmedVentAnterior70802(i)=mean(Pvent70802(i,1:j));
    
    j=1;
    while Tpulmao70803(i,j)<=Tpulmao70803(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior70803(i)=mean(Pasp70803(i,1:j));
    PmedVentAnterior70803(i)=mean(Pvent70803(i,1:j));
    
    
    j=1;
    while Tpulmao71001(i,j)<=Tpulmao71001(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior71001(i)=mean(Pasp71001(i,1:j));
    PmedVentAnterior71001(i)=mean(Pvent71001(i,1:j));
    
    j=1;
    while Tpulmao71002(i,j)<=Tpulmao71002(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior71002(i)=mean(Pasp71002(i,1:j));
    PmedVentAnterior71002(i)=mean(Pvent71002(i,1:j));
    
    j=1;
    while Tpulmao71003(i,j)<=Tpulmao71003(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior71003(i)=mean(Pasp71003(i,1:j));
    PmedVentAnterior71003(i)=mean(Pvent71003(i,1:j));
    
    
    j=1;
    while Tpulmao80601(i,j)<=Tpulmao80601(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior80601(i)=mean(Pasp80601(i,1:j));
    PmedVentAnterior80601(i)=mean(Pvent80601(i,1:j));
    
    j=1;
    while Tpulmao80602(i,j)<=Tpulmao80602(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior80602(i)=mean(Pasp80602(i,1:j));
    PmedVentAnterior80602(i)=mean(Pvent80602(i,1:j));
    
    j=1;
    while Tpulmao80603(i,j)<=Tpulmao80603(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior80603(i)=mean(Pasp80603(i,1:j));
    PmedVentAnterior80603(i)=mean(Pvent80603(i,1:j));
    
    
    j=1;
    while Tpulmao80801(i,j)<=Tpulmao80801(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior80801(i)=mean(Pasp80801(i,1:j));
    PmedVentAnterior80801(i)=mean(Pvent80801(i,1:j));
    
    j=1;
    while Tpulmao80802(i,j)<=Tpulmao80802(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior80802(i)=mean(Pasp80802(i,1:j));
    PmedVentAnterior80802(i)=mean(Pvent80802(i,1:j));
    
    j=1;
    while Tpulmao80803(i,j)<=Tpulmao80803(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior80803(i)=mean(Pasp80803(i,1:j));
    PmedVentAnterior80803(i)=mean(Pvent80803(i,1:j));
    
    
    j=1;
    while Tpulmao81001(i,j)<=Tpulmao81001(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81001(i)=mean(Pasp81001(i,1:j));
    PmedVentAnterior81001(i)=mean(Pvent81001(i,1:j));
    
    j=1;
    while Tpulmao81002(i,j)<=Tpulmao81002(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81002(i)=mean(Pasp81002(i,1:j));
    PmedVentAnterior81002(i)=mean(Pvent81002(i,1:j));
    
    j=1;
    while Tpulmao81003(i,j)<=Tpulmao81003(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81003(i)=mean(Pasp81003(i,1:j));
    PmedVentAnterior81003(i)=mean(Pvent81003(i,1:j));
    
    
    j=1;
    while Tpulmao81E01(i,j)<=Tpulmao81E01(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81E01(i)=mean(Pasp81E01(i,1:j));
    PmedVentAnterior81E01(i)=mean(Pvent81E01(i,1:j));
    
    j=1;
    while Tpulmao81E02(i,j)<=Tpulmao81E02(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81E02(i)=mean(Pasp81E02(i,1:j));
    PmedVentAnterior81E02(i)=mean(Pvent81E02(i,1:j));
    
    j=1;
    while Tpulmao81E03(i,j)<=Tpulmao81E03(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81E03(i)=mean(Pasp81E03(i,1:j));
    PmedVentAnterior81E03(i)=mean(Pvent81E03(i,1:j));
    
    
    j=1;
    while Tpulmao81M01(i,j)<=Tpulmao81M01(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81M01(i)=mean(Pasp81M01(i,1:j));
    PmedVentAnterior81M01(i)=mean(Pvent81M01(i,1:j));
    
    j=1;
    while Tpulmao81M02(i,j)<=Tpulmao81M02(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81M02(i)=mean(Pasp81M02(i,1:j));
    PmedVentAnterior81M02(i)=mean(Pvent81M02(i,1:j));
    
    j=1;
    while Tpulmao81M03(i,j)<=Tpulmao81M03(i,1)+seconds(4)
        j=j+1;
    end
    PmedAspAnterior81M03(i)=mean(Pasp81M03(i,1:j));
    PmedVentAnterior81M03(i)=mean(Pvent81M03(i,1:j));
end

PressaoRef = [5 5 5 10 10 10 15 15 15]';
figure
scatter([PmedAsp70601;PmedAspAnterior70601],[PressaoRef - PmedVent70601;PressaoRef - PmedVentAnterior70601],'b')
hold on
scatter([PmedAsp70801;PmedAspAnterior70801],[PressaoRef - PmedVent70801;PressaoRef - PmedVentAnterior70801],'r')
scatter([PmedAsp71001;PmedAspAnterior71001],[PressaoRef - PmedVent71001;PressaoRef - PmedVentAnterior71001],'g')
scatter([PmedAsp80601;PmedAspAnterior80601],[PressaoRef - PmedVent80601;PressaoRef - PmedVentAnterior80601],'c')
scatter([PmedAsp80801;PmedAspAnterior80801],[PressaoRef - PmedVent80801;PressaoRef - PmedVentAnterior80801],'m')
scatter([PmedAsp81001;PmedAspAnterior81001],[PressaoRef - PmedVent81001;PressaoRef - PmedVentAnterior81001],'y')
scatter([PmedAsp81E01;PmedAspAnterior81E01],[PressaoRef - PmedVent81E01;PressaoRef - PmedVentAnterior81E01],'k')

scatter([PmedAsp70602;PmedAspAnterior70602],[PressaoRef - PmedVent70602;PressaoRef - PmedVentAnterior70602],'b')
scatter([PmedAsp70603;PmedAspAnterior70603],[PressaoRef - PmedVent70603;PressaoRef - PmedVentAnterior70603],'b')
scatter([PmedAsp70802;PmedAspAnterior70802],[PressaoRef - PmedVent70802;PressaoRef - PmedVentAnterior70802],'r')
scatter([PmedAsp70803;PmedAspAnterior70803],[PressaoRef - PmedVent70803;PressaoRef - PmedVentAnterior70803],'r')
scatter([PmedAsp71002;PmedAspAnterior71002],[PressaoRef - PmedVent71002;PressaoRef - PmedVentAnterior71002],'g')
scatter([PmedAsp71003;PmedAspAnterior71003],[PressaoRef - PmedVent71003;PressaoRef - PmedVentAnterior71003],'g')
scatter([PmedAsp80602;PmedAspAnterior80602],[PressaoRef - PmedVent80602;PressaoRef - PmedVentAnterior80602],'c')
scatter([PmedAsp80603;PmedAspAnterior80603],[PressaoRef - PmedVent80603;PressaoRef - PmedVentAnterior80603],'c')
scatter([PmedAsp80802;PmedAspAnterior80802],[PressaoRef - PmedVent80802;PressaoRef - PmedVentAnterior80802],'m')
scatter([PmedAsp80803;PmedAspAnterior80803],[PressaoRef - PmedVent80803;PressaoRef - PmedVentAnterior80803],'m')
scatter([PmedAsp81002;PmedAspAnterior81002],[PressaoRef - PmedVent81002;PressaoRef - PmedVentAnterior81002],'y')
scatter([PmedAsp81003;PmedAspAnterior81003],[PressaoRef - PmedVent81003;PressaoRef - PmedVentAnterior81003],'y')
scatter([PmedAsp81E02;PmedAspAnterior81E02],[PressaoRef - PmedVent81E02;PressaoRef - PmedVentAnterior81E02],'k')
scatter([PmedAsp81E03;PmedAspAnterior81E03],[PressaoRef - PmedVent81E03;PressaoRef - PmedVentAnterior81E03],'k')
scatter([PmedAsp81M01;PmedAspAnterior81M01],[PressaoRef - PmedVent81M01;PressaoRef - PmedVentAnterior81M01],'k')
scatter([PmedAsp81M02;PmedAspAnterior81M02],[PressaoRef - PmedVent81M02;PressaoRef - PmedVentAnterior81M02],'k')
scatter([PmedAsp81M03;PmedAspAnterior81M03],[PressaoRef - PmedVent81M03;PressaoRef - PmedVentAnterior81M03],'k')
hold off
xlabel('Pressure Suction [cmH_2O]')
ylabel('Pressure Set - Pressure Ventilation [cmH_2O]')
legend('TOT 7.5 Sonda 06','TOT 7.5 Sonda 08','TOT 7.5 Sonda 10','TOT 8.5 Sonda 06','TOT 8.5 Sonda 08','TOT 8.5 Sonda 10','TOT 8.5 Sonda 12','location','Northwest')
title({'Grafico de Queda de Pressão do Ventilador x Pressão de Aspiração','Para calculo de pertubação da aspiração no ventilador pelo cftool'})

X706a = [(PmedAsp70601)' (PmedAsp70602)' (PmedAsp70603)'];
X708a = [(PmedAsp70801)' (PmedAsp70802)' (PmedAsp70803)'];
X710a = [(PmedAsp71001)' (PmedAsp71002)' (PmedAsp71003)'];
X806a = [(PmedAsp80601)' (PmedAsp80602)' (PmedAsp80603)'];
X808a = [(PmedAsp80801)' (PmedAsp80802)' (PmedAsp80803)'];
X810a = [(PmedAsp81001)' (PmedAsp81002)' (PmedAsp81003)'];
X812a = [(PmedAsp81E01)' (PmedAsp81E02)' (PmedAsp81E03)' (PmedAsp81M01)' (PmedAsp81M02)' (PmedAsp81M03)'];
Y706a = [(PressaoRef-PmedVent70601)' (PressaoRef-PmedVent70602)' (PressaoRef-PmedVent70603)'];
Y708a = [(PressaoRef-PmedVent70801)' (PressaoRef-PmedVent70802)' (PressaoRef-PmedVent70803)'];
Y710a = [(PressaoRef-PmedVent71001)' (PressaoRef-PmedVent71002)' (PressaoRef-PmedVent71003)'];
Y806a = [(PressaoRef-PmedVent80601)' (PressaoRef-PmedVent80602)' (PressaoRef-PmedVent80603)'];
Y808a = [(PressaoRef-PmedVent80801)' (PressaoRef-PmedVent80802)' (PressaoRef-PmedVent80803)'];
Y810a = [(PressaoRef-PmedVent81001)' (PressaoRef-PmedVent81002)' (PressaoRef-PmedVent81003)'];
Y812a = [(PressaoRef-PmedVent81E01)' (PressaoRef-PmedVent81E02)' (PressaoRef-PmedVent81E03)' (PressaoRef-PmedVent81M01)' (PressaoRef-PmedVent81M02)' (PressaoRef-PmedVent81M03)'];
%Utilizando o cftool
%Eq QuedaPvent = a*Pasp+b (Polynomial - 1 Degree - Robust Off)
PaspSimulada = 0:-1:-150;
Pqueda706a = -0.001148*PaspSimulada+0.369;
Pqueda708a = -0.008725*PaspSimulada+0.365;
Pqueda710a = -0.01768*PaspSimulada+1.433;
Pqueda806a = -0.01103*PaspSimulada+0.2219;
Pqueda808a = -0.01171*PaspSimulada+1.592;
Pqueda810a = -0.03016*PaspSimulada+1.294;
Pqueda812a = 0.03951*PaspSimulada+2.515;
figure
scatter(X706a,Y706a,'b')
hold on
scatter(X708a,Y708a,'r')
scatter(X710a,Y710a,'g')
scatter(X806a,Y806a,'c')
scatter(X808a,Y808a,'m')
scatter(X810a,Y810a,'y')
scatter(X812a,Y812a,'k')
plot(PaspSimulada,Pqueda706a,'b')
plot(PaspSimulada,Pqueda708a,'r')
plot(PaspSimulada,Pqueda710a,'g')
plot(PaspSimulada,Pqueda806a,'c')
plot(PaspSimulada,Pqueda808a,'m')
plot(PaspSimulada,Pqueda810a,'y')
plot(PaspSimulada,Pqueda812a,'k')
hold off
xlabel('Pressure Suction [cmH_2O]')
ylabel('Pressure Set - Pressure Ventilation [cmH_2O]')
title({'Grafico de Pressão de Aspiração x Queda de Pressão de Ventilação','Para calculo da interferencia do aspirador no ventilador pelo cftool','Usando apenas os pontos durante a aspiração'})
legend('TOT 7.5 Sonda 06','TOT 7.5 Sonda 08','TOT 7.5 Sonda 10','TOT 8.5 Sonda 06','TOT 8.5 Sonda 08','TOT 8.5 Sonda 10','TOT 8.5 Sonda 12','location','Northeast')




X706b = [(PmedAsp70601)' (PmedAspAnterior70601)' (PmedAsp70602)' (PmedAspAnterior70602)' (PmedAsp70603)' (PmedAspAnterior70603)'];
X708b = [(PmedAsp70801)' (PmedAspAnterior70801)' (PmedAsp70802)' (PmedAspAnterior70802)' (PmedAsp70803)' (PmedAspAnterior70803)'];
X710b = [(PmedAsp71001)' (PmedAspAnterior71001)' (PmedAsp71002)' (PmedAspAnterior71002)' (PmedAsp71003)' (PmedAspAnterior71003)'];
X806b = [(PmedAsp80601)' (PmedAspAnterior80601)' (PmedAsp80602)' (PmedAspAnterior80602)' (PmedAsp80603)' (PmedAspAnterior80603)'];
X808b = [(PmedAsp80801)' (PmedAspAnterior80801)' (PmedAsp80802)' (PmedAspAnterior80802)' (PmedAsp80803)' (PmedAspAnterior80803)'];
X810b = [(PmedAsp81001)' (PmedAspAnterior81001)' (PmedAsp81002)' (PmedAspAnterior81002)' (PmedAsp81003)' (PmedAspAnterior81003)'];
X812b = [(PmedAsp81E01)' (PmedAspAnterior81E01)' (PmedAsp81E02)' (PmedAspAnterior81E02)' (PmedAsp81E03)' (PmedAspAnterior81E03)' (PmedAsp81M01)' (PmedAspAnterior81M01)' (PmedAsp81M02)' (PmedAspAnterior81M02)' (PmedAsp81M03)' (PmedAspAnterior81M03)'];
Y706b = [(PressaoRef-PmedVent70601)' (PressaoRef - PmedVentAnterior70601)' (PressaoRef-PmedVent70602)' (PressaoRef - PmedVentAnterior70602)' (PressaoRef-PmedVent70603)' (PressaoRef - PmedVentAnterior70603)'];
Y708b = [(PressaoRef-PmedVent70801)' (PressaoRef - PmedVentAnterior70801)' (PressaoRef-PmedVent70802)' (PressaoRef - PmedVentAnterior70802)' (PressaoRef-PmedVent70803)' (PressaoRef - PmedVentAnterior70803)'];
Y710b = [(PressaoRef-PmedVent71001)' (PressaoRef - PmedVentAnterior71001)' (PressaoRef-PmedVent71002)' (PressaoRef - PmedVentAnterior71002)' (PressaoRef-PmedVent71003)' (PressaoRef - PmedVentAnterior71003)'];
Y806b = [(PressaoRef-PmedVent80601)' (PressaoRef - PmedVentAnterior80601)' (PressaoRef-PmedVent80602)' (PressaoRef - PmedVentAnterior80602)' (PressaoRef-PmedVent80603)' (PressaoRef - PmedVentAnterior80603)'];
Y808b = [(PressaoRef-PmedVent80801)' (PressaoRef - PmedVentAnterior80801)' (PressaoRef-PmedVent80802)' (PressaoRef - PmedVentAnterior80802)' (PressaoRef-PmedVent80803)' (PressaoRef - PmedVentAnterior80803)'];
Y810b = [(PressaoRef-PmedVent81001)' (PressaoRef - PmedVentAnterior81001)' (PressaoRef-PmedVent81002)' (PressaoRef - PmedVentAnterior81002)' (PressaoRef-PmedVent81003)' (PressaoRef - PmedVentAnterior81003)'];
Y812b = [(PressaoRef-PmedVent81E01)' (PressaoRef - PmedVentAnterior81E01)' (PressaoRef-PmedVent81E02)' (PressaoRef - PmedVentAnterior81E02)' (PressaoRef-PmedVent81E03)' (PressaoRef - PmedVentAnterior81E03)' (PressaoRef-PmedVent81M01)' (PressaoRef - PmedVentAnterior81M01)' (PressaoRef-PmedVent81M02)' (PressaoRef - PmedVentAnterior81M02)' (PressaoRef-PmedVent81M03)' (PressaoRef - PmedVentAnterior81M03)'];
%Utilizando o cftool
%Eq QuedaPvent = a*Pasp+b (Polynomial - 1 Degree - Robust Off)
PaspSimulada = 0:-1:-150;
Pqueda706b = -0.00235*PaspSimulada+0.2535;
Pqueda708b = -0.01294*PaspSimulada+0.1899;
Pqueda710b = -0.03382*PaspSimulada+0.9449;
Pqueda806b = -0.009146*PaspSimulada+0.3947;
Pqueda808b = -0.03089*PaspSimulada+0.8912;
Pqueda810b = -0.05433*PaspSimulada+0.9346;
Pqueda812b = -0.06652*PaspSimulada+1.668;
figure
plot(X706b,Y706b,'bo')
hold on
plot(X708b,Y708b,'ro')
plot(X710b,Y710b,'go')
plot(X806b,Y806b,'b+')
plot(X808b,Y808b,'r+')
plot(X810b,Y810b,'g+')
plot(X812b,Y812b,'k+')
plot(PaspSimulada,Pqueda706b,'b')
plot(PaspSimulada,Pqueda708b,'r')
plot(PaspSimulada,Pqueda710b,'g')
plot(PaspSimulada,Pqueda806b,'b--')
plot(PaspSimulada,Pqueda808b,'r--')
plot(PaspSimulada,Pqueda810b,'g--')
plot(PaspSimulada,Pqueda812b,'k--')
hold off
xlabel('Pressure Suction [cmH_2O]')
ylabel('Pressure Set - Pressure Ventilation [cmH_2O]')
title({'Grafico de Pressão de Aspiração x Queda de Pressão de Ventilação','Para calculo da interferencia do aspirador no ventilador pelo cftool','Usando os pontos durante a aspiração e de repouso'})
legend('TOT 7.5 Sonda 06','TOT 7.5 Sonda 08','TOT 7.5 Sonda 10','TOT 8.5 Sonda 06','TOT 8.5 Sonda 08','TOT 8.5 Sonda 10','TOT 8.5 Sonda 12','location','Northeast')

%Comparando os dois plots
figure
scatter(X706a,Y706a,'b')
hold on
scatter(X708a,Y708a,'r')
scatter(X710a,Y710a,'g')
scatter(X806a,Y806a,'c')
scatter(X808a,Y808a,'m')
scatter(X810a,Y810a,'y')
scatter(X812a,Y812a,'k')
plot(PaspSimulada,Pqueda706a,'b')
plot(PaspSimulada,Pqueda708a,'r')
plot(PaspSimulada,Pqueda710a,'g')
plot(PaspSimulada,Pqueda806a,'c')
plot(PaspSimulada,Pqueda808a,'m')
plot(PaspSimulada,Pqueda810a,'y')
plot(PaspSimulada,Pqueda812a,'k')
scatter(X706b,Y706b,'b')
scatter(X708b,Y708b,'r')
scatter(X710b,Y710b,'g')
scatter(X806b,Y806b,'c')
scatter(X808b,Y808b,'m')
scatter(X810b,Y810b,'y')
scatter(X812b,Y812b,'k')
plot(PaspSimulada,Pqueda706b,'b--')
plot(PaspSimulada,Pqueda708b,'r--')
plot(PaspSimulada,Pqueda710b,'g--')
plot(PaspSimulada,Pqueda806b,'c--')
plot(PaspSimulada,Pqueda808b,'m--')
plot(PaspSimulada,Pqueda810b,'y--')
plot(PaspSimulada,Pqueda812b,'k--')
hold off
xlabel('Pressure Suction [cmH_2O]')
ylabel('Pressure Set - Pressure Ventilation [cmH_2O]')
title({'Grafico de Pressão de Aspiração x Queda de Pressão de Ventilação','Para calculo da interferencia do aspirador no ventilador pelo cftool','Continua - Usando apenas os pontos durante a aspiração','Pontilhado - Usando os pontos durante a aspiração e de repouso'})
legend('TOT 7.5 Sonda 06','TOT 7.5 Sonda 08','TOT 7.5 Sonda 10','TOT 8.5 Sonda 06','TOT 8.5 Sonda 08','TOT 8.5 Sonda 10','TOT 8.5 Sonda 12','location','Northeast')
