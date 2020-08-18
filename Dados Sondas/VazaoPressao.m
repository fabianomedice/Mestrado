function [X,Y] = VazaoPressao(filename)
%Calcula os R1 e R2 de y[k] = R1 x[k]^1/2 + R2 x[k]

clc
close all

Dados = importTDMS(filename);

Pressao = Dados.tred.pressure.val;
Vazao = Dados.tred.flow.val;

%---------------------------------------
%Conferindo e Retirando dados de erro do sensor
%---------------------------------------
%Erro 1: Valor de pressão mais negativa que -70 [cmH2O]
%Este erro faz com que o valor de pressão vá para a casa dos 632 [cmH2O]
%Erro 2: Valor de pressão mais alta que 87,8790 [cmH2O]
%Este erro faz com que o valor de pressão sature em 87,8790 [cmH2O]

indice = zeros(length(Pressao),1);

for k=1:1:length(Pressao)
    if (Pressao(k)>87) %Atente ambos os erros
        indice(k)=k;
    end
end

%Retira os zeros do indice
tf = indice(:)==0;
indice(tf,:) = [];

if (indice > 0)
    disp(' ')
    disp('Ha erro de medicao')
    disp('Indice das variaveis retiradas')
    disp(indice)
    disp('Porcentagem dos dados retirados')
    Porcentagem = [num2str((length(indice)/length(Pressao))*100), '%'];
    disp(Porcentagem)
    
    %Retira os valores colocado pelo indice
    for k=1:1:length(indice)
        Pressao([indice(k)-k+1])=[]; %Remove o dado
        Vazao([indice(k)-k+1])=[]; %Remove o dado
    end
end

%---------------------------------------
%Iniciando as analises
%---------------------------------------

%Separando em valor positivo e negativo
idx = Pressao<0; %Criando Index Logico
Negativo = zeros(2,length(Pressao(idx)));
Positivo = zeros(2,length(Pressao(~idx)));

Neg=1;
Pos=1;
for k=1:1:length(Pressao)
    if (Pressao(k)<0)
        Negativo(1,Neg)=Vazao(k);
        Negativo(2,Neg)=Pressao(k);
        Neg = Neg+1;
    else
        Positivo(1,Pos)=Vazao(k);
        Positivo(2,Pos)=Pressao(k);
        Pos = Pos +1;
    end
end

X = Positivo(2,:);
Y = Positivo(1,:);
% 
% Regressores = zeros(length(Y),2);
% for k=1:1:length(Regressores)
%     Regressores(k,1) = X(k)^(1/2);
%     Regressores(k,2) = X(k);
% end
% %Parâmetros
% %R = (Regressores'Regressores)^(-1) Regressores'Y
% R = Regressores\Y'
% 
% %Plots
% 
% figure
% scatter(X,Y,'b')
% xlabel('Pressao [cmH2O]')
% ylabel('Vazao [L/s]')
% hold on
% Pressao_Estimada = 0:0.5:max(X);
% Vazao_Estimado =(R(1)*Pressao_Estimada.^(1/2)+R(2)*Pressao_Estimada);
% plot(Pressao_Estimada, Vazao_Estimado,'r')
% % legend('Pressao', 'Pressao Estimada','Location','northwest')
% hold off

disp('Vazão Maxima')
max(Y)

end