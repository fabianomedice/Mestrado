clc
clear all
close all

%% Leitura dos Dados

Name = 'TuboYTOT75.txt';
% Name = 'TuboYBeda.txt';

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

%% ------------------------------------
% Criando o time series
%%-------------------------------------

Ventilation = timetable(seconds(Time1),Pressure1,Flow1,'VariableNames',{'Pressure','Flow'});
% Ventilador = timeseries([Pressure1,Flow1],Time1,['Pressure','Flow'])
Lung = timetable(seconds(Time2),Pressure2,Flow2,'VariableNames',{'Pressure','Flow'});
Suction = timetable(seconds(Time3),Pressure3,Flow3,'VariableNames',{'Pressure','Flow'});

%synchronize %sincroniza os dados
Data = synchronize(Ventilation,Lung,Suction,'union','previous');

figure (1)
plot (Data.Time,Data.Pressure_Ventilation,'b',Data.Time,Data.Pressure_Lung,'r',Data.Time,Data.Pressure_Suction,'g')
legend('Ventilation','Lung','Suction','Location','Best')
xlabel('Time')
ylabel('Pressure [cmH2O]')

figure (2)
plot (Data.Time,Data.Flow_Ventilation,'b',Data.Time,Data.Flow_Lung,'r',Data.Time,Data.Flow_Suction,'g')
legend('Ventilation','Lung','Suction','Location','Best')
xlabel('Time')
ylabel('Flow [L/s]')

% P = Data.Pressure_Ventilation-Data.Pressure_Lung;
% F = Data.Flow_Ventilation;
P = Data.Pressure_Lung;
F = Data.Flow_Lung;

for i=length(P):-1:1
%     if F(i)<0
%         P(i) = [];
%         F(i) = [];
%     end
    if P(i)<0
        P(i) = [];
        F(i) = [];
    end
%     if P(i)>3
%         P(i) = [];
%         F(i) = [];
%     end
end
Ptest = 0:0.1:60;
FtestTotal = 0.2491.*Ptest.^0.6086;
FtestTuboY = 0.9759.*Ptest.^0.3639;
FtestTOT75a = 0.3833*Ptest.^0.5872; %anterior
FtestTOT75n = 0.2625*Ptest.^0.5739; %nova

plot(FtestTotal,Ptest./FtestTotal,'k')
hold on
plot(FtestTuboY,Ptest./FtestTuboY,'r')
plot(FtestTOT75n,Ptest./FtestTOT75n,'b')
plot(FtestTOT75a,Ptest./FtestTOT75a+Ptest./FtestTuboY,'g')
hold off
