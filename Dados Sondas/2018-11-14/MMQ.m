function MMQ(filename)
%Calcula a função de transferencia da sonda

clc
close all

Dados = importTDMS(filename);
disp(' ')
disp(' ')

Pressao = Dados.tred.pressure.val;
Vazao = Dados.tred.flow.val;
Tempo = Dados.tred.time.val;
Tempo = Tempo - Tempo(1);

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = Theta1 x[k]^.2 + Theta2 x[k]
X=Pressao;
Y=Vazao;

% % % % %---------------------------------------
% % % % %Iniciando as analises
% % % % %---------------------------------------
% % % % 
% % % % %Separando em valor positivo e negativo
% % % % idx = Pressao<0; %Criando Index Logico
% % % % Negativo = zeros(2,length(Pressao(idx)));
% % % % Positivo = zeros(2,length(Pressao(~idx)));
% % % % 
% % % % Neg=1;
% % % % Pos=1;
% % % % for k=1:1:length(Pressao)
% % % %     if (Pressao(k)<0)
% % % %         Negativo(1,Neg)=Vazao(k);
% % % %         Negativo(2,Neg)=Pressao(k);
% % % %         Neg = Neg+1;
% % % %     else
% % % %         Positivo(1,Pos)=Vazao(k);
% % % %         Positivo(2,Pos)=Pressao(k);
% % % %         Pos = Pos +1;
% % % %     end
% % % % end
% % % % 
% % % % X = Positivo(2,:);
% % % % Y = Positivo(1,:);

Regressores1 = zeros(length(Y),2);
for k=1:1:length(Regressores1)
    Regressores1(k,1) = X(k)^2;
    Regressores1(k,2) = X(k);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores de V[k] = Theta(1) P[k]^2 + Theta(2) P[k]')
Theta1 = Regressores1\Y

Vazao_Estimada_1 = Theta1(1)*Pressao.^2+Theta1(2)*Pressao;

Residuo_1 = Vazao-Vazao_Estimada_1;

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = Theta1 x[k-1]^.2 + Theta2 x[k-1]
X=Pressao;
Y=Vazao;

Regressores2 = zeros(length(Y),2);
%carregando o primeiro
for k=2:1:length(Regressores2)
    Regressores2(k,1) = X(k-1)^2;
    Regressores2(k,2) = X(k-1);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores de V[k] = Theta(1) P[k-1]^2 + Theta(2) P[k-1]')
Theta2 = Regressores2\Y

Vazao_Estimada_2 = zeros(length(Vazao),1);
for k=2:1:length(Vazao_Estimada_2)
    Vazao_Estimada_2(k) = Theta2(1)*Pressao(k-1).^2+Theta2(2)*Pressao(k-1);
end

Residuo_2 = Vazao-Vazao_Estimada_2;


%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = Theta1 x[k-1]^.2 + Theta2 x[k-1] + Theta3 y[k-1]
X=Pressao;
Y=Vazao;

Regressores3 = zeros(length(Y),3);
%carregando o primeiro
for k=2:1:length(Regressores3)
    Regressores3(k,1) = X(k-1)^2;
    Regressores3(k,2) = X(k-1);
    Regressores3(k,3) = Y(k-1);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores de V[k] = Theta(1) P[k-1]^2 + Theta(2) P[k-1] + Theta(3) V[k-1]')
Theta3 = Regressores3\Y

Vazao_Estimada_3 = zeros(length(Vazao),1);
for k=2:1:length(Vazao_Estimada_3)
    Vazao_Estimada_3(k) = Theta3(1)*Pressao(k-1).^2+Theta3(2)*Pressao(k-1)+Theta3(3)*Vazao_Estimada_3(k-1);
end

Residuo_3 = Vazao-Vazao_Estimada_3;

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = Theta1 x[k]^.2 + Theta2 x[k] + Theta3
% X=Pressao;
% Y=Vazao;

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

Regressores4 = zeros(length(Y),3);
for k=1:1:length(Regressores4)
    Regressores4(k,1) = X(k)^2;
    Regressores4(k,2) = X(k);
    Regressores4(k,3) = 1;       
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores de V[k] = Theta(1) P[k]^2 + Theta(2) P[k]')
Theta4 = Regressores4\Y'

Vazao_Estimada_4 = Theta4(1)*Pressao.^2+Theta4(2)*Pressao+Theta4(3);

Residuo_4 = Vazao-Vazao_Estimada_4;


figure
plot(Tempo,Vazao,Tempo,Vazao_Estimada_1,Tempo,Vazao_Estimada_4)
legend('Dados','Theta(1) P[k]^2 + Theta(2) P[k]','Theta(1) P[k]^2 + Theta(2) P[k] + Theta(3)')


%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = Theta1 x[k-1]^.2 + Theta2 x[k-1] + Theta3 y[k-1]
X=Pressao;
Y=Vazao;

Regressores5 = zeros(length(Y),3);
%carregando o primeiro
for k=2:1:length(Regressores5)
    Regressores5(k,1) = X(k-1)^2;
    Regressores5(k,2) = X(k-1);
    Regressores5(k,3) = Y(k-1);
    Regressores5(k,4) = Y(k-1)^2;
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores de V[k] = Theta(1) P[k-1]^2 + Theta(2) P[k-1] + Theta(3) V[k-1] + Theta(4) V[k-1]^2')
Theta5 = Regressores5\Y

Vazao_Estimada_5 = zeros(length(Vazao),1);
for k=2:1:length(Vazao_Estimada_5)
    Vazao_Estimada_5(k) = Theta5(1)*Pressao(k-1).^2+Theta5(2)*Pressao(k-1)+Theta5(3)*Vazao_Estimada_5(k-1)+Theta5(4)*Vazao_Estimada_5(k-1).^2;
end

Residuo_5 = Vazao-Vazao_Estimada_5;



%Plots
figure
plot(Tempo,Vazao,Tempo,Vazao_Estimada_1,Tempo,Vazao_Estimada_2,Tempo,Vazao_Estimada_3,Tempo,Vazao_Estimada_5)
legend('Dados','Theta(1) P[k]^2 + Theta(2) P[k]','Theta(1) P[k-1]^2 + Theta(2) P[k-1]','Theta(1) P[k-1]^2 + Theta(2) P[k-1] + Theta(3) V[k-1]','Theta(1) P[k-1]^2 + Theta(2) P[k-1] + Theta(3) V[k-1] + Theta(4) V[k-1]^2')

disp('RSME modelo 1')
sqrt(mean(Residuo_1)^2)
disp('Erro absoluto máximo 1')
max(abs(Residuo_1))

disp('RSME modelo 2')
sqrt(mean(Residuo_2)^2)
disp('Erro absoluto máximo 2')
max(abs(Residuo_2))

disp('RSME modelo 3')
sqrt(mean(Residuo_3)^2)
disp('Erro absoluto máximo 3')
max(abs(Residuo_3))
