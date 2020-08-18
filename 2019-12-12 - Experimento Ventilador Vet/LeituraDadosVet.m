clear all
clc

%Leitura dos Dados

Name = 'M12FR003_TOT8.5_Vet.txt';


if Name(end-3:end)=='.lvm'
    Dados = lvm_import(Name,2);
    
    Channel_1 = Dados.Segment1.data(:,1);
    Channel_2 = Dados.Segment1.data(:,2);
    Channel_3 = Dados.Segment1.data(:,3);
%     Channel_4 = Dados.Segment1.data(:,5);
%     Channel_5 = Dados.Segment1.data(:,6);
%     Channel_6 = Dados.Segment1.data(:,7);
%     Channel_7 = Dados.Segment1.data(:,8);
%     Channel_8 = Dados.Segment1.data(:,9);
%     Channel_9 = Dados.Segment1.data(:,10);
    
    Time1 = Channel_1(2:end);
%     Time2 = Channel_4;
%     Time3 = Channel_7;
    Pressure1 = Channel_3(2:end);
%     Pressure2 = Channel_6;
%     Pressure3 = Channel_9;
    Flow1 = Channel_2(2:end);
%     Flow2 = Channel_5;
%     Flow3 = Channel_8;
    
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

% % % figure (1)
% % % plot(Time1,Pressure1,'b')
% % % hold on
% % % plot(Time2,Pressure2,'r')
% % % plot(Time3,Pressure3,'g')
% % % legend ('Ventilador','Pulm�o','Aspirador')
% % % xlabel('Time')
% % % ylabel('Pressure')
% % % title('Sinal de Pressao')
% % % hold off
% % % 
% % % figure (2)
% % % plot(Time1,Flow1,'b')
% % % hold on
% % % plot(Time2,Flow2,'r')
% % % plot(Time3,Flow3,'g')
% % % legend ('Ventilador','Pulm�o','Aspirador')
% % % xlabel('Time')
% % % ylabel('Flow')
% % % title('Sinal de Vazao')
% % % hold off
% % % 
% % % figure(3)
% % % plot(Time1,Pressure1,'r',Time1,Flow1*10,'b')
% % % legend('Press�o', '10*Vaz�o')
%% ------------------------------------
% Conserto de BUG
%%-------------------------------------
%Por iniciarem as grava��es dos dados em tempos diferentes, h� varios vetores com zero em todas as variaveis

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

%% ------------------------------------
% Criando o time series
%%-------------------------------------

Ventilation = timetable(seconds(Time1),Pressure1,Flow1,'VariableNames',{'Pressure','Flow'});
Lung = timetable(seconds(Time2),Pressure2,Flow2,'VariableNames',{'Pressure','Flow'});
Suction = timetable(seconds(Time3),Pressure3,Flow3,'VariableNames',{'Pressure','Flow'});

%synchronize %sincroniza os dados
Data = synchronize(Ventilation,Lung,Suction,'union','previous');
%Criando vetor de vaz�o para o pulm�o
%Considerando que n�o h� vazamentos, a vaz�o do pulm�o � igual ao tanto de vaz�o que vem do ventilador mais a que � retirada pela a suc��o
% % % % % % % % Data.Flow_Lung = Data.Flow_Ventilation + Data.Flow_Suction;

figure (1)
% plot (Data.Time,Data.Pressure_Ventilation,'b')
% legend('Ventilation','Location','Best')
plot (Data.Time,Data.Pressure_Ventilation,'b',Data.Time,Data.Pressure_Lung,'r',Data.Time,Data.Pressure_Suction,'g')
legend('Ventilation','Lung','Suction','Location','Best')
xlabel('Time')
ylabel('Pressure [cmH2O]')

figure (2)
plot(Data.Time,Data.Flow_Ventilation,'b',Data.Time,Data.Flow_Lung,'r',Data.Time,Data.Flow_Suction,'g')
legend('Ventilation','Lung','Suction','Location','Best')
xlabel('Time')
ylabel('Flow [L/s]')


figure(5)
spectrum(Pressure1)

%Filtro para melhor visualiza��o
% Hz=0.1;
Hz=1;
[B, A]=butter(2,2*Hz/100);
PFiltrado = filtfilt(B,A,Pressure1);
FFiltrado = filtfilt(B,A,Flow1);

figure(6)
plot(Time1,Flow1,'b')
hold on
plot(Time1,FFiltrado,'r')
hold off
title('Compara��o entre o sinal de Vaz�o com o sinal de Vaz�o Filtrado')

figure(7)
plot(Time1,Pressure1,'b')
hold on
plot(Time1,PFiltrado,'r')
hold off
title('Compara��o entre o sinal de Pressao com o sinal de Pressao Filtrado')
% % % 
% % % % close all
% % % 
% % % figure(8)
% % % plot(Time1,PFiltrado,'r',Time1,FFiltrado*10,'b')
% % % legend('Press�o', '10*Vaz�o')
