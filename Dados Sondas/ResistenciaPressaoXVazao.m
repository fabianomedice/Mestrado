clc
close all

%Vazão Estimada
V_06 = 0:0.001:0.0420; 
V_08 = 0:0.001:0.1720;
V_10 = 0:0.001:0.2067;
V_12 = 0:0.001:0.3533;
V_14 = 0:0.001:0.5493;


%Pressões estimadas
P_E06FR001 = (14626.0000*V_06.^2+1162.0000*V_06);
P_E06FR002 = (17295.0000*V_06.^2+1168.0000*V_06);
P_E06FR003 = (16873.0000*V_06.^2+1166.0000*V_06);
P_E08FR001 = (2211.8000*V_08.^2+151.0000*V_08);
P_E08FR002 = (1687.4000*V_08.^2+107.1000*V_08);
P_E08FR003 = (2009.0000*V_08.^2+144.6000*V_08);
P_M10FR001 = (1382.3000*V_10.^2+85.6000*V_10);
P_M10FR002 = (1632.8000*V_10.^2+71.2000*V_10);
P_M10FR003 = (1486.0000*V_10.^2+72.4000*V_10);
P_E12FR001 = (570.1455*V_12.^2+29.6031*V_12);
P_E12FR002 = (583.5637*V_12.^2+31.9550*V_12);
P_E12FR003 = (616.5230*V_12.^2+29.5643*V_12);
P_M12FR001 = (470.2197*V_12.^2+28.5151*V_12);
P_M12FR002 = (507.4931*V_12.^2+35.5900*V_12);
P_M12FR003 = (445.2180*V_12.^2+24.6047*V_12);
P_M14FR001 = (200.2923*V_14.^2+15.8841*V_14);
P_M14FR002 = (218.2120*V_14.^2+16.5191*V_14);
P_M14FR003 = (189.8002*V_14.^2+15.1760*V_14);

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = R1 x[k]^.2 + R2 x[k]
Y_06 = zeros(1,length(V_06)*3);
Y_06(1:3:end-2)= P_E06FR001;
Y_06(2:3:end-1)= P_E06FR002;
Y_06(3:3:end)= P_E06FR003;
X_06 = repelem(V_06,3);

Regressores_06 = zeros(length(Y_06),2);
for k=1:1:length(Regressores_06)
    Regressores_06(k,1) = X_06(k)^2;
    Regressores_06(k,2) = X_06(k);
end

Y_08 = zeros(1,length(V_08)*3);
Y_08(1:3:end-2)= P_E08FR001;
Y_08(2:3:end-1)= P_E08FR002;
Y_08(3:3:end)= P_E08FR003;
X_08 = repelem(V_08,3);

Regressores_08 = zeros(length(Y_08),2);
for k=1:1:length(Regressores_08)
    Regressores_08(k,1) = X_08(k)^2;
    Regressores_08(k,2) = X_08(k);
end

Y_10 = zeros(1,length(V_10)*3);
Y_10(1:3:end-2)= P_M10FR001;
Y_10(2:3:end-1)= P_M10FR002;
Y_10(3:3:end)= P_M10FR003;
X_10 = repelem(V_10,3);

Regressores_10 = zeros(length(Y_10),2);
for k=1:1:length(Regressores_10)
    Regressores_10(k,1) = X_10(k)^2;
    Regressores_10(k,2) = X_10(k);
end

Y_12 = zeros(1,length(V_12)*6);
Y_12(1:6:end-5)= P_E12FR001;
Y_12(2:6:end-4)= P_E12FR002;
Y_12(3:6:end-3)= P_E12FR003;
Y_12(4:6:end-2)= P_M12FR001;
Y_12(5:6:end-1)= P_M12FR002;
Y_12(6:6:end)= P_M12FR003;
X_12 = repelem(V_12,6);

Regressores_12 = zeros(length(Y_12),2);
for k=1:1:length(Regressores_12)
    Regressores_12(k,1) = X_12(k)^2;
    Regressores_12(k,2) = X_12(k);
end

Y_12E = zeros(1,length(V_12)*3);
Y_12E(1:3:end-2)= P_E12FR001;
Y_12E(2:3:end-1)= P_E12FR002;
Y_12E(3:3:end)= P_E12FR003;
X_12E = repelem(V_12,3);

Regressores_12E = zeros(length(Y_12E),2);
for k=1:1:length(Regressores_12E)
    Regressores_12E(k,1) = X_12E(k)^2;
    Regressores_12E(k,2) = X_12E(k);
end

Y_12M = zeros(1,length(V_12)*3);
Y_12M(1:3:end-2)= P_M12FR001;
Y_12M(2:3:end-1)= P_M12FR002;
Y_12M(3:3:end)= P_M12FR003;
X_12M = repelem(V_12,3);

Regressores_12M = zeros(length(Y_12E),2);
for k=1:1:length(Regressores_12M)
    Regressores_12M(k,1) = X_12M(k)^2;
    Regressores_12M(k,2) = X_12M(k);
end

Y_14 = zeros(1,length(V_14)*3);
Y_14(1:3:end-2)= P_M14FR001;
Y_14(2:3:end-1)= P_M14FR002;
Y_14(3:3:end)= P_M14FR003;
X_14 = repelem(V_14,3);

Regressores_14 = zeros(length(Y_14),2);
for k=1:1:length(Regressores_14)
    Regressores_14(k,1) = X_14(k)^2;
    Regressores_14(k,2) = X_14(k);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores das Sondas')
R_06 = Regressores_06\Y_06'
R_08 = Regressores_08\Y_08'
R_10 = Regressores_10\Y_10'
R_12 = Regressores_12\Y_12'
R_12E = Regressores_12E\Y_12E'
R_12M = Regressores_12M\Y_12M'
R_14 = Regressores_14\Y_14'

% figure
% plot(V,P_E06FR001./V,'-.b', V,P_E06FR002./V,'-.g', V,P_E06FR003./V,'-.r', V,P_E08FR001./V,'-b', V,P_E08FR002./V,'-g', V,P_E08FR003./V,'-r', V,P_M10FR001./V,'-c', V,P_M10FR002./V,'-m', V,P_M10FR003./V,'-y', V,P_E12FR001./V,'--b', V,P_E12FR002./V, '--g',V,P_E12FR003./V,'--r', V,P_M12FR001./V,'--c', V,P_M12FR002./V,'--m', V,P_M12FR003./V,'--y', V,P_M14FR001./V,':b', V,P_M14FR002./V,':g', V,P_M14FR003./V,':r')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% ylim([0 1500])
% legend('E06FR001','E06FR002','E06FR003','E08FR001','E08FR002','E08FR003','M10FR001','M10FR002','M10FR003','E12FR001','E12FR002','E12FR003','M12FR001','M12FR002','M12FR003','M14FR001','M14FR002','M14FR003','Location','northwest')
% title('Resistências das Sondas')

% figure
% plot(V_06,P_E06FR001./V_06,'b', V_06,P_E06FR002./V_06,'b', V_06,P_E06FR003./V_06,'b', V_08,P_E08FR001./V_08,'g', V_08,P_E08FR002./V_08,'g', V_08,P_E08FR003./V_08,'g', V_10,P_M10FR001./V_10,'r', V_10,P_M10FR002./V_10,'r', V_10,P_M10FR003./V_10,'r', V_12,P_E12FR001./V_12,'k', V_12,P_E12FR002./V_12, 'k',V_12,P_E12FR003./V_12,'k', V_12,P_M12FR001./V_12,'k', V_12,P_M12FR002./V_12,'k', V_12,P_M12FR003./V_12,'k', V_14,P_M14FR001./V_14,'m', V_14,P_M14FR002./V_14,'m', V_14,P_M14FR003./V_14,'m')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% legend('06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','14FR','14FR','14FR','Location','northeast')
% title('Resistências das Sondas')

figure
plot(V_12,P_E12FR001./V_12,':b', V_12,P_E12FR002./V_12,':b',V_12,P_E12FR003./V_12,':b',V_12,(R_12E(1)*V_12.^2+R_12E(2)*V_12)./V_12,'b', V_12,P_M12FR001./V_12,':r', V_12,P_M12FR002./V_12,':r', V_12,P_M12FR003./V_12,':r',V_12,(R_12M(1)*V_12.^2+R_12M(2)*V_12)./V_12,'r',V_12,(R_12(1)*V_12.^2+R_12(2)*V_12)./V_12,'k')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
legend('E12FR','E12FR','E12FR','E12FR Médio','M12FR','M12FR','M12FR','M12FR Médio','12FR Médio','Location','northwest')
title('Resistências das Sondas')

figure
plot(V_06,P_E06FR001./V_06,':b', V_06,P_E06FR002./V_06,':b', V_06,P_E06FR003./V_06,':b',V_06,(R_06(1)*V_06.^2+R_06(2)*V_06)./V_06,'b', V_08,P_E08FR001./V_08,':g', V_08,P_E08FR002./V_08,':g', V_08,P_E08FR003./V_08,':g',V_08,(R_08(1)*V_08.^2+R_08(2)*V_08)./V_08,'g', V_10,P_M10FR001./V_10,':r', V_10,P_M10FR002./V_10,':r', V_10,P_M10FR003./V_10,':r',V_10,(R_10(1)*V_10.^2+R_10(2)*V_10)./V_10,'r', V_12,P_E12FR001./V_12,':k', V_12,P_E12FR002./V_12,':k',V_12,P_E12FR003./V_12,':k', V_12,P_M12FR001./V_12,':k', V_12,P_M12FR002./V_12,':k', V_12,P_M12FR003./V_12,':k',V_12,(R_12(1)*V_12.^2+R_12(2)*V_12)./V_12,'k', V_14,P_M14FR001./V_14,':m', V_14,P_M14FR002./V_14,':m', V_14,P_M14FR003./V_14,':m',V_14,(R_14(1)*V_14.^2+R_14(2)*V_14)./V_14,'m')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
legend('06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','12FR','12FR','12FR','12FR','12FR','12FR','12FR Médio','14FR','14FR','14FR','14FR Médio','Location','northeast')
title('Resistências das Sondas')

%TESTE
figure
plot(P_E06FR001,P_E06FR001./V_06,':b', P_E06FR002,P_E06FR002./V_06,':b', P_E06FR003,P_E06FR003./V_06,':b',(R_06(1)*V_06.^2+R_06(2)*V_06),(R_06(1)*V_06.^2+R_06(2)*V_06)./V_06,'b', P_E08FR001,P_E08FR001./V_08,':g', P_E08FR002,P_E08FR002./V_08,':g', P_E08FR003,P_E08FR003./V_08,':g',(R_08(1)*V_08.^2+R_08(2)*V_08),(R_08(1)*V_08.^2+R_08(2)*V_08)./V_08,'g', P_M10FR001,P_M10FR001./V_10,':r', P_M10FR002,P_M10FR002./V_10,':r', P_M10FR003,P_M10FR003./V_10,':r',(R_10(1)*V_10.^2+R_10(2)*V_10),(R_10(1)*V_10.^2+R_10(2)*V_10)./V_10,'r', P_E12FR001,P_E12FR001./V_12,':k', P_E12FR002,P_E12FR002./V_12,':k',P_E12FR003,P_E12FR003./V_12,':k',P_M12FR001,P_M12FR001./V_12,':k', P_M12FR002,P_M12FR002./V_12,':k', P_M12FR003,P_M12FR003./V_12,':k',(R_12(1)*V_12.^2+R_12(2)*V_12),(R_12(1)*V_12.^2+R_12(2)*V_12)./V_12,'k', P_M14FR001,P_M14FR001./V_14,':m', P_M14FR002,P_M14FR002./V_14,':m', P_M14FR003,P_M14FR003./V_14,':m',(R_14(1)*V_14.^2+R_14(2)*V_14),(R_14(1)*V_14.^2+R_14(2)*V_14)./V_14,'m')
xlabel('Pressão [cmH2O]')
ylabel('Resistência [cmH2O/L/s]')
legend('06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','12FR','12FR','12FR','12FR','12FR','12FR','12FR Médio','14FR','14FR','14FR','14FR Médio','Location','northeast')
title('Resistências das Sondas')

%Vazão Estimada
V_TOT7_5 = 0:0.001:3.6860;

%Pressões estimadas para TOT 7,5
P_Sem_Sonda = (3.4606*V_TOT7_5.^2+1.0814*V_TOT7_5);
P_E06FR001 = (4.9152*V_TOT7_5.^2+1.7538*V_TOT7_5);
P_E06FR002 = (5.0025*V_TOT7_5.^2+1.8443*V_TOT7_5);
P_E06FR003 = (4.7321*V_TOT7_5.^2+2.1007*V_TOT7_5);
P_E08FR001 = (6.8322*V_TOT7_5.^2+2.9106*V_TOT7_5);
P_E08FR002 = (6.8048*V_TOT7_5.^2+2.8293*V_TOT7_5);
P_E08FR003 = (6.3931*V_TOT7_5.^2+2.8104*V_TOT7_5);
P_M10FR001 = (6.0046*V_TOT7_5.^2+4.2265*V_TOT7_5);
P_M10FR002 = (7.3693*V_TOT7_5.^2+1.9607*V_TOT7_5);
P_M10FR003 = (6.2218*V_TOT7_5.^2+4.1339*V_TOT7_5);

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = R1 x[k]^.2 + R2 x[k]
Y_06 = zeros(1,length(V_TOT7_5)*3);
Y_06(1:3:end-2)= P_E06FR001;
Y_06(2:3:end-1)= P_E06FR002;
Y_06(3:3:end)= P_E06FR003;
X_06 = repelem(V_TOT7_5,3);

Regressores_06 = zeros(length(Y_06),2);
for k=1:1:length(Regressores_06)
    Regressores_06(k,1) = X_06(k)^2;
    Regressores_06(k,2) = X_06(k);
end

Y_08 = zeros(1,length(V_TOT7_5)*3);
Y_08(1:3:end-2)= P_E08FR001;
Y_08(2:3:end-1)= P_E08FR002;
Y_08(3:3:end)= P_E08FR003;
X_08 = repelem(V_TOT7_5,3);

Regressores_08 = zeros(length(Y_08),2);
for k=1:1:length(Regressores_08)
    Regressores_08(k,1) = X_08(k)^2;
    Regressores_08(k,2) = X_08(k);
end

Y_10 = zeros(1,length(V_TOT7_5)*3);
Y_10(1:3:end-2)= P_M10FR001;
Y_10(2:3:end-1)= P_M10FR002;
Y_10(3:3:end)= P_M10FR003;
X_10 = repelem(V_TOT7_5,3);

Regressores_10 = zeros(length(Y_10),2);
for k=1:1:length(Regressores_10)
    Regressores_10(k,1) = X_10(k)^2;
    Regressores_10(k,2) = X_10(k);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores das Sondas dentro do TOT de 7,5')
R_06 = Regressores_06\Y_06'
R_08 = Regressores_08\Y_08'
R_10 = Regressores_10\Y_10'

% % figure
% % plot(V_TOT7_5,P_Sem_Sonda./V_TOT7_5,':b', V_TOT7_5,P_E06FR001./V_TOT7_5,'-b', V_TOT7_5,P_E06FR002./V_TOT7_5,'-g', V_TOT7_5,P_E06FR003./V_TOT7_5,'-r', V_TOT7_5,P_E08FR001./V_TOT7_5,'--b', V_TOT7_5,P_E08FR002./V_TOT7_5,'--g', V_TOT7_5,P_E08FR003./V_TOT7_5,'--r', V_TOT7_5,P_M10FR001./V_TOT7_5,'-.b', V_TOT7_5,P_M10FR002./V_TOT7_5,'-.g', V_TOT7_5,P_M10FR003./V_TOT7_5,'-.r')
% % xlabel('V_TOT7_5azao [L/s]')
% % ylabel('Resistência [cmH2O/L/s]')
% % title('Resistencias do TOT 7,5')
% % legend('Sem Sonda','E06FR001','E06FR002','E06FR003','E08FR001','E08FR002','E08FR003','M10FR001','M10FR002','M10FR003','Location','northwest')

% figure
% plot(V_TOT7_5,P_Sem_Sonda./V_TOT7_5,'b', V_TOT7_5,P_E06FR001./V_TOT7_5,'g', V_TOT7_5,P_E06FR002./V_TOT7_5,'g', V_TOT7_5,P_E06FR003./V_TOT7_5,'g', V_TOT7_5,P_E08FR001./V_TOT7_5,'r', V_TOT7_5,P_E08FR002./V_TOT7_5,'r', V_TOT7_5,P_E08FR003./V_TOT7_5,'r', V_TOT7_5,P_M10FR001./V_TOT7_5,'k', V_TOT7_5,P_M10FR002./V_TOT7_5,'k', V_TOT7_5,P_M10FR003./V_TOT7_5,'k')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% title('Resistências do TOT 7,5')
% legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','Location','northwest')

figure
plot(V_TOT7_5,P_Sem_Sonda./V_TOT7_5,'b', V_TOT7_5,P_E06FR001./V_TOT7_5,':g', V_TOT7_5,P_E06FR002./V_TOT7_5,':g', V_TOT7_5,P_E06FR003./V_TOT7_5,':g',V_TOT7_5,(R_06(1)*V_TOT7_5.^2+R_06(2)*V_TOT7_5)./V_TOT7_5,'g', V_TOT7_5,P_E08FR001./V_TOT7_5,':r', V_TOT7_5,P_E08FR002./V_TOT7_5,':r', V_TOT7_5,P_E08FR003./V_TOT7_5,':r',V_TOT7_5,(R_08(1)*V_TOT7_5.^2+R_08(2)*V_TOT7_5)./V_TOT7_5,'r', V_TOT7_5,P_M10FR001./V_TOT7_5,':k', V_TOT7_5,P_M10FR002./V_TOT7_5,':k', V_TOT7_5,P_M10FR003./V_TOT7_5,':k',V_TOT7_5,(R_10(1)*V_TOT7_5.^2+R_10(2)*V_TOT7_5)./V_TOT7_5,'k')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
title('Resistências do TOT 7,5')
legend('Sem Sonda','06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','Location','northwest')

%Vazão Estimada
V_TOT8_5 = 0:0.001:5.1113;

%Pressões estimadas para TOT 8,5
P_Sem_Sonda = (1.9411*V_TOT8_5.^2+0.6589*V_TOT8_5);
P_E06FR001 = (2.4831*V_TOT8_5.^2+1.4874*V_TOT8_5);
P_E06FR002 = (2.5083*V_TOT8_5.^2+1.3619*V_TOT8_5);
P_E06FR003 = (2.4312*V_TOT8_5.^2+1.5349*V_TOT8_5);
P_E08FR001 = (3.2438*V_TOT8_5.^2+2.1600*V_TOT8_5);
P_E08FR002 = (3.1499*V_TOT8_5.^2+2.1288*V_TOT8_5);
P_E08FR003 = (3.1628*V_TOT8_5.^2+1.7227*V_TOT8_5);
P_M10FR001 = (3.2853*V_TOT8_5.^2+1.8037*V_TOT8_5);
P_M10FR002 = (3.1359*V_TOT8_5.^2+1.9179*V_TOT8_5);
P_M10FR003 = (3.1671*V_TOT8_5.^2+1.6981*V_TOT8_5);
P_E12FR001 = (4.0756*V_TOT8_5.^2+3.1665*V_TOT8_5);
P_E12FR002 = (4.0106*V_TOT8_5.^2+3.0654*V_TOT8_5);
P_E12FR003 = (3.7684*V_TOT8_5.^2+2.9826*V_TOT8_5);
P_M12FR001 = (3.8500*V_TOT8_5.^2+2.6827*V_TOT8_5);
P_M12FR002 = (4.2328*V_TOT8_5.^2+4.0203*V_TOT8_5);
P_M12FR003 = (3.7356*V_TOT8_5.^2+3.0635*V_TOT8_5);

%---------------------------------------
%Minimos Quadrados
%---------------------------------------
%y[k] = R1 x[k]^.2 + R2 x[k]
Y_06 = zeros(1,length(V_TOT8_5)*3);
Y_06(1:3:end-2)= P_E06FR001;
Y_06(2:3:end-1)= P_E06FR002;
Y_06(3:3:end)= P_E06FR003;
X_06 = repelem(V_TOT8_5,3);

Regressores_06 = zeros(length(Y_06),2);
for k=1:1:length(Regressores_06)
    Regressores_06(k,1) = X_06(k)^2;
    Regressores_06(k,2) = X_06(k);
end

Y_08 = zeros(1,length(V_TOT8_5)*3);
Y_08(1:3:end-2)= P_E08FR001;
Y_08(2:3:end-1)= P_E08FR002;
Y_08(3:3:end)= P_E08FR003;
X_08 = repelem(V_TOT8_5,3);

Regressores_08 = zeros(length(Y_08),2);
for k=1:1:length(Regressores_08)
    Regressores_08(k,1) = X_08(k)^2;
    Regressores_08(k,2) = X_08(k);
end

Y_10 = zeros(1,length(V_TOT8_5)*3);
Y_10(1:3:end-2)= P_M10FR001;
Y_10(2:3:end-1)= P_M10FR002;
Y_10(3:3:end)= P_M10FR003;
X_10 = repelem(V_TOT8_5,3);

Regressores_10 = zeros(length(Y_10),2);
for k=1:1:length(Regressores_10)
    Regressores_10(k,1) = X_10(k)^2;
    Regressores_10(k,2) = X_10(k);
end

Y_12 = zeros(1,length(V_TOT8_5)*6);
Y_12(1:6:end-5)= P_E12FR001;
Y_12(2:6:end-4)= P_E12FR002;
Y_12(3:6:end-3)= P_E12FR003;
Y_12(4:6:end-2)= P_M12FR001;
Y_12(5:6:end-1)= P_M12FR002;
Y_12(6:6:end)= P_M12FR003;
X_12 = repelem(V_TOT8_5,6);

Regressores_12 = zeros(length(Y_12),2);
for k=1:1:length(Regressores_12)
    Regressores_12(k,1) = X_12(k)^2;
    Regressores_12(k,2) = X_12(k);
end

%Parâmetros
%R = (Regressores'Regressores)^(-1) Regressores'Y
disp('Regressores das Sondas dentro do TOT de 8,5')
R_06 = Regressores_06\Y_06'
R_08 = Regressores_08\Y_08'
R_10 = Regressores_10\Y_10'
R_12 = Regressores_12\Y_12'

% figure
% plot(V_TOT8_5,P_Sem_Sonda./V_TOT8_5,'b', V_TOT8_5,P_E06FR001./V_TOT8_5,'g', V_TOT8_5,P_E06FR002./V_TOT8_5,'g', V_TOT8_5,P_E06FR003./V_TOT8_5,'g', V_TOT8_5,P_E08FR001./V_TOT8_5,'r', V_TOT8_5,P_E08FR002./V_TOT8_5,'r', V_TOT8_5,P_E08FR003./V_TOT8_5,'r', V_TOT8_5,P_M10FR001./V_TOT8_5,'m', V_TOT8_5,P_M10FR002./V_TOT8_5,'m', V_TOT8_5,P_M10FR003./V_TOT8_5,'m', V_TOT8_5,P_E12FR001./V_TOT8_5,'k', V_TOT8_5,P_E12FR002./V_TOT8_5,'k', V_TOT8_5,P_E12FR003./V_TOT8_5,'k', V_TOT8_5,P_M12FR001./V_TOT8_5,'k', V_TOT8_5,P_M12FR002./V_TOT8_5,'k', V_TOT8_5,P_M12FR003./V_TOT8_5,'k')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% title('Resistências do TOT 8,5')
% legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','Location','northwest')

figure
plot(V_TOT8_5,P_E12FR001./V_TOT8_5,':b', V_TOT8_5,P_E12FR002./V_TOT8_5,':b', V_TOT8_5,P_E12FR003./V_TOT8_5,':b', V_TOT8_5,P_M12FR001./V_TOT8_5,':r', V_TOT8_5,P_M12FR002./V_TOT8_5,':r', V_TOT8_5,P_M12FR003./V_TOT8_5,':r',V_TOT8_5,(R_12(1)*V_TOT8_5.^2+R_12(2)*V_TOT8_5)./V_TOT8_5,'k')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
title('Resistências do TOT 8,5')
legend('E12FR','E12FR','E12FR','M12FR','M12FR','M12FR','12FR Médio','Location','northwest')


figure
plot(V_TOT8_5,P_Sem_Sonda./V_TOT8_5,'b', V_TOT8_5,P_E06FR001./V_TOT8_5,':g', V_TOT8_5,P_E06FR002./V_TOT8_5,':g', V_TOT8_5,P_E06FR003./V_TOT8_5,':g',V_TOT8_5,(R_06(1)*V_TOT8_5.^2+R_06(2)*V_TOT8_5)./V_TOT8_5,'g', V_TOT8_5,P_E08FR001./V_TOT8_5,':r', V_TOT8_5,P_E08FR002./V_TOT8_5,':r', V_TOT8_5,P_E08FR003./V_TOT8_5,':r',V_TOT8_5,(R_08(1)*V_TOT8_5.^2+R_08(2)*V_TOT8_5)./V_TOT8_5,'r', V_TOT8_5,P_M10FR001./V_TOT8_5,':m', V_TOT8_5,P_M10FR002./V_TOT8_5,':m', V_TOT8_5,P_M10FR003./V_TOT8_5,':m',V_TOT8_5,(R_10(1)*V_TOT8_5.^2+R_10(2)*V_TOT8_5)./V_TOT8_5,'m', V_TOT8_5,P_E12FR001./V_TOT8_5,':k', V_TOT8_5,P_E12FR002./V_TOT8_5,':k', V_TOT8_5,P_E12FR003./V_TOT8_5,':k', V_TOT8_5,P_M12FR001./V_TOT8_5,':k', V_TOT8_5,P_M12FR002./V_TOT8_5,':k', V_TOT8_5,P_M12FR003./V_TOT8_5,':k',V_TOT8_5,(R_12(1)*V_TOT8_5.^2+R_12(2)*V_TOT8_5)./V_TOT8_5,'k')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
title('Resistências do TOT 8,5')
legend('Sem Sonda','06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','12FR','12FR','12FR','12FR','12FR','12FR','12FR Médio','Location','northwest')

