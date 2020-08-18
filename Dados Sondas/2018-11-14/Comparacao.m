clear all
close all
clc

[Pressao,Vazao]=VazaoPressao('M12FR001_2018_11_14.tdms');

X_Total = [0:0.1:max(Pressao)];
X_Zoom = [0:0.1:20];

%Modelo com constante
a1=0.04369;
b1=0.5083;
c1=-0.02214;

Y_Total_C = a1*X_Total.^b1+c1;
Y_Zoom_C = a1*X_Zoom.^b1+c1;

%Modelo sem constante
a2=0.032;
b2=0.5709;

Y_Total_S = a2*X_Total.^b2;
Y_Zoom_S = a2*X_Zoom.^b2;

Pressao_Zoom = Pressao;
Vazao_Zoom=Vazao;
for i=1:length(Pressao)
    if Pressao(i)>20
        Pressao_Zoom(i)=1000;
        Vazao_Zoom(i)=1000;
    end
end
Pressao_Zoom = Pressao_Zoom(Pressao_Zoom~=1000);
Vazao_Zoom = Vazao_Zoom(Vazao_Zoom~=1000);

%Plot Completo
figure
scatter(Pressao,Vazao)
hold on
plot(X_Total,Y_Total_C,X_Total,Y_Total_S)
legend('Dados','Com Constante','Sem Constante','Location', 'Best')
xlabel('Pressao [cmH2O]')
ylabel('Vazao [L/s]')
hold off
title('Sonda M12FR001')

%Plot Zoom
figure
scatter(Pressao_Zoom,Vazao_Zoom)
hold on
plot(X_Zoom,Y_Zoom_C,X_Zoom,Y_Zoom_S)
legend('Dados','Com Constante','Sem Constante','Location', 'Best')
xlabel('Pressao [cmH2O]')
ylabel('Vazao [L/s]')
hold off
title('Sonda M12FR001')