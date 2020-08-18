clc
clear all
close all

Name = 'M10FR002_TOT7.5_Vet.txt';

Data = LeituraDados (Name);

%Fazendo a Equação
Pressao = -2:0.01:5;
Vazao = 0.2682*abs(Pressao).^0.5726.*sign(Pressao);


figure(3)
scatter(Data.Flow_Ventilation,Data.Pressure_Ventilation-Data.Pressure_Lung)
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao,Pressao)
legend('Dados M10FR002 TOT7.5 Vet','Equação Identificada')
hold off