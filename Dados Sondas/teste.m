function Dados = ResistenciasSondas(filename)
%Calcula os R1 e R2 de y[k] = R1 x[k]^.2 + R2 x[k]

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

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = R1 x[k]^.2 + R2 x[k]
Y = Pressao;
X = Vazao;
% Y = Pressao(1:20:length(Pressao));
% X = Vazao(1:20:length(Vazao));
Regressores = zeros(length(Y),2);
for k=1:1:length(Regressores)
    Regressores(k,1) = X(k)^2;
    Regressores(k,2) = X(k);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
R = polyfit(X,abs(Y),2) %Método 2
R1 = Regressores\abs(Y) %Método 1
R2 = polyfit(X,abs(Y),2) %Método 2
R3 = lsqnonneg(Regressores,abs(Y)) %Método 3


%Plots

figure
scatter(abs(Negativo(1,:)),abs(Negativo(2,:)),'b')
xlabel('Vazao [L/s]')
ylabel('Pressao [cmH2O]')
hold on
scatter(Positivo(1,:),Positivo(2,:),'r')
xlabel('Vazao [L/s]')
ylabel('Pressao [cmH2O]')
Vazao_Estimado = 0:0.0001:max(Vazao);
Pressao_Estimada = (R(1)*Vazao_Estimado.^2+R(2)*abs(Vazao_Estimado)).*sign(Vazao_Estimado)+R(3);
scatter(Vazao_Estimado ,Pressao_Estimada,'g')
legend('|Pressao Negativa|','Pressao Positiva', 'Pressao Estimada','Location','northwest')
hold off

figure
scatter(Vazao,Pressao,'b')
xlabel('Vazao [L/s]')
ylabel('Pressao [cmH2O]')
hold on
Vazao_Estimado = min(Vazao):0.0001:max(Vazao);
Pressao_Estimada = (R(1)*Vazao_Estimado.^2+R(2)*abs(Vazao_Estimado)).*sign(Vazao_Estimado)+R(3);
scatter(Vazao_Estimado ,Pressao_Estimada,'g')
legend('Pressao', 'Pressao Estimada','Location','northwest')
hold off
% 
figure
scatter(Vazao,Pressao)
xlabel('Vazao [L/s]')
ylabel('Pressao [cmH2O]')
hold on
Vazao_Estimado = min(Vazao):0.0001:max(Vazao);
Pressao_Estimada = (R1(1)*Vazao_Estimado.^2+R1(2)*abs(Vazao_Estimado)).*sign(Vazao_Estimado);
scatter(Vazao_Estimado ,Pressao_Estimada)
Vazao_Estimado = min(Vazao):0.0001:max(Vazao);
Pressao_Estimada = (R2(1)*Vazao_Estimado.^2+R2(2)*abs(Vazao_Estimado)).*sign(Vazao_Estimado)+R2(3);
scatter(Vazao_Estimado ,Pressao_Estimada)
Vazao_Estimado = min(Vazao):0.0001:max(Vazao);
Pressao_Estimada = (R3(1)*Vazao_Estimado.^2+R3(2)*abs(Vazao_Estimado)).*sign(Vazao_Estimado);
scatter(Vazao_Estimado ,Pressao_Estimada)
legend('Pressao', 'Pressao Metodo 1', 'Pressao Metodo 2', 'Pressao Metodo 3','Location','northwest')
hold off

end

