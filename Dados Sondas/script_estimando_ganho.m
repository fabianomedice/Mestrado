% clc
% clear all
% close all

N = 100;
Ts = 1/100; % tempo de amostragem
x = unnamed(:,2);
y = unnamed(:,1);
% % % x = randn(N,1); % y é uma coluna, isso faz diferença nas multiplicações seguintes
% % % y = zeros(size(x));
% % % e = 0.1*randn(N,1);
% % % t = 0:Ts:(N-1)*Ts;
% % % 
% % % % simulando a seguinte função transferência:
% % % % Y(Z)       b*z^-1
% % % % ----  = --------------  
% % % % X(Z)     1   -  a*z^-1
% % % % onde: b = -0.7 e a = -0.2
% % % b = 0.7;
% % % a = -0.2;
% % % Gz_original = tf([0 b],[1 -a],Ts)
% % % for k = 2:N
% % %     y(k) = -a*y(k-1) +b*x(k-1) + e(k); 
% % % end

% % % figure(1)
% % % plot(t,x,'b-',t,y,'r-')
% % % hold on
% % % plot(t,x,'b.',t,y,'r.')
% % % legend('x[k]','y[k]')
% % % xlabel('Tempo (seg)')
% % % ylabel('Amplitude (???)')
% % % grid on
% % % hold off


% Mínimos quadrados
A = [y(1:end-1) x(1:end-1)]; % matriz dos regressores
b = y(2:end);
% outra forma de fazer (modelo de 2.a ordem)
% A = [lagmatrix(y,1:2) lagmatrix(x,1:2)]; % lagmatrix preserva o tamanho e insere NaN
% b = y;
% A = A(2:end,:);
% b = b(2:end);

theta = A\b ; % mais eficiente do que inverter matriz e com menos erro numérico
Gz_modelo = tf([0 theta(2)],[1 theta(1)],Ts)
ganho = theta(2)/(1+theta(1)) % teorema do valor final quando a entrada é o degrau (z/z-1) com z-> 1


figure(2)
% step(Gz_original,Gz_modelo)
% legend('Original','Modelo')
step(Gz_modelo)

figure(3)
lsim(Gz_modelo,x,t)
hold on
stairs(t,y,'r')
legend('Modelo','Real')


