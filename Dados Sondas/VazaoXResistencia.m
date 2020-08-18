clc
close all

V = 0:0.001:0.5; %Vazão Estimada

%Pressões estimadas
P_E06FR001 = (14626.0000*V.^2+1162.0000*abs(V)).*sign(V);
P_E06FR002 = (17295.0000*V.^2+1168.0000*abs(V)).*sign(V);
P_E06FR003 = (16873.0000*V.^2+1166.0000*abs(V)).*sign(V);
P_E08FR001 = (2211.8000*V.^2+151.0000*abs(V)).*sign(V);
P_E08FR002 = (1687.4000*V.^2+107.1000*abs(V)).*sign(V);
P_E08FR003 = (2009.0000*V.^2+144.6000*abs(V)).*sign(V);
P_M10FR001 = (1382.3000*V.^2+85.6000*abs(V)).*sign(V);
P_M10FR002 = (1632.8000*V.^2+71.2000*abs(V)).*sign(V);
P_M10FR003 = (1486.0000*V.^2+72.4000*abs(V)).*sign(V);
P_E12FR001 = (570.1455*V.^2+29.6031*abs(V)).*sign(V);
P_E12FR002 = (583.5637*V.^2+31.9550*abs(V)).*sign(V);
P_E12FR003 = (616.5230*V.^2+29.5643*abs(V)).*sign(V);
P_M12FR001 = (470.2197*V.^2+28.5151*abs(V)).*sign(V);
P_M12FR002 = (507.4931*V.^2+35.5900*abs(V)).*sign(V);
P_M12FR003 = (445.2180*V.^2+24.6047*abs(V)).*sign(V);
P_M14FR001 = (200.2923*V.^2+15.8841*abs(V)).*sign(V);
P_M14FR002 = (218.2120*V.^2+16.5191*abs(V)).*sign(V);
P_M14FR003 = (189.8002*V.^2+15.1760*abs(V)).*sign(V);

% figure
% plot(V,P_E06FR001./V,'-.b', V,P_E06FR002./V,'-.g', V,P_E06FR003./V,'-.r', V,P_E08FR001./V,'-b', V,P_E08FR002./V,'-g', V,P_E08FR003./V,'-r', V,P_M10FR001./V,'-c', V,P_M10FR002./V,'-m', V,P_M10FR003./V,'-y', V,P_E12FR001./V,'--b', V,P_E12FR002./V, '--g',V,P_E12FR003./V,'--r', V,P_M12FR001./V,'--c', V,P_M12FR002./V,'--m', V,P_M12FR003./V,'--y', V,P_M14FR001./V,':b', V,P_M14FR002./V,':g', V,P_M14FR003./V,':r')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% ylim([0 1500])
% legend('E06FR001','E06FR002','E06FR003','E08FR001','E08FR002','E08FR003','M10FR001','M10FR002','M10FR003','E12FR001','E12FR002','E12FR003','M12FR001','M12FR002','M12FR003','M14FR001','M14FR002','M14FR003','Location','northwest')
% title('Resistencias das Sondas')

figure
plot(V,P_E06FR001./V,'b', V,P_E06FR002./V,'b', V,P_E06FR003./V,'b', V,P_E08FR001./V,'g', V,P_E08FR002./V,'g', V,P_E08FR003./V,'g', V,P_M10FR001./V,'r', V,P_M10FR002./V,'r', V,P_M10FR003./V,'r', V,P_E12FR001./V,'k', V,P_E12FR002./V, 'k',V,P_E12FR003./V,'k', V,P_M12FR001./V,'k', V,P_M12FR002./V,'k', V,P_M12FR003./V,'k', V,P_M14FR001./V,'m', V,P_M14FR002./V,'m', V,P_M14FR003./V,'m')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
ylim([0 1500])
legend('06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','14FR','14FR','14FR','Location','northwest')
title('Resistencias das Sondas')

%Pressões estimadas para TOT 7,5
P_Sem_Sonda = (3.4606*V.^2+1.0814*abs(V)).*sign(V);
P_E06FR001 = (4.9152*V.^2+1.7538*abs(V)).*sign(V);
P_E06FR002 = (5.0025*V.^2+1.8443*abs(V)).*sign(V);
P_E06FR003 = (4.7321*V.^2+2.1007*abs(V)).*sign(V);
P_E08FR001 = (6.8322*V.^2+2.9106*abs(V)).*sign(V);
P_E08FR002 = (6.8048*V.^2+2.8293*abs(V)).*sign(V);
P_E08FR003 = (6.3931*V.^2+2.8104*abs(V)).*sign(V);
P_M10FR001 = (6.0046*V.^2+4.2265*abs(V)).*sign(V);
P_M10FR002 = (7.3693*V.^2+1.9607*abs(V)).*sign(V);
P_M10FR003 = (6.2218*V.^2+4.1339*abs(V)).*sign(V);

% % figure
% % plot(V,P_Sem_Sonda./V,':b', V,P_E06FR001./V,'-b', V,P_E06FR002./V,'-g', V,P_E06FR003./V,'-r', V,P_E08FR001./V,'--b', V,P_E08FR002./V,'--g', V,P_E08FR003./V,'--r', V,P_M10FR001./V,'-.b', V,P_M10FR002./V,'-.g', V,P_M10FR003./V,'-.r')
% % xlabel('Vazao [L/s]')
% % ylabel('Resistência [cmH2O/L/s]')
% % title('Resistencias do TOT 7,5')
% % legend('Sem Sonda','E06FR001','E06FR002','E06FR003','E08FR001','E08FR002','E08FR003','M10FR001','M10FR002','M10FR003','Location','northwest')

figure
plot(V,P_Sem_Sonda./V,'b', V,P_E06FR001./V,'g', V,P_E06FR002./V,'g', V,P_E06FR003./V,'g', V,P_E08FR001./V,'r', V,P_E08FR002./V,'r', V,P_E08FR003./V,'r', V,P_M10FR001./V,'m', V,P_M10FR002./V,'m', V,P_M10FR003./V,'m')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
title('Resistências do TOT 7,5')
legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','Location','northwest')

%Pressões estimadas para TOT 8,5
P_Sem_Sonda = (1.9411*V.^2+0.6589*abs(V)).*sign(V);
P_E06FR001 = (2.4831*V.^2+1.4874*abs(V)).*sign(V);
P_E06FR002 = (2.5083*V.^2+1.3619*abs(V)).*sign(V);
P_E06FR003 = (2.4312*V.^2+1.5349*abs(V)).*sign(V);
P_E08FR001 = (3.2438*V.^2+2.1600*abs(V)).*sign(V);
P_E08FR002 = (3.1499*V.^2+2.1288*abs(V)).*sign(V);
P_E08FR003 = (3.1628*V.^2+1.7227*abs(V)).*sign(V);
P_M10FR001 = (3.2853*V.^2+1.8037*abs(V)).*sign(V);
P_M10FR002 = (3.1359*V.^2+1.9179*abs(V)).*sign(V);
P_M10FR003 = (3.1671*V.^2+1.6981*abs(V)).*sign(V);
P_E12FR001 = (4.0756*V.^2+3.1665*abs(V)).*sign(V);
P_E12FR002 = (4.0106*V.^2+3.0654*abs(V)).*sign(V);
P_E12FR003 = (3.7684*V.^2+2.9826*abs(V)).*sign(V);
P_M12FR001 = (3.8500*V.^2+2.6827*abs(V)).*sign(V);
P_M12FR002 = (4.2328*V.^2+4.0203*abs(V)).*sign(V);
P_M12FR003 = (3.7356*V.^2+3.0635*abs(V)).*sign(V);

figure
plot(V,P_Sem_Sonda./V,'b', V,P_E06FR001./V,'g', V,P_E06FR002./V,'g', V,P_E06FR003./V,'g', V,P_E08FR001./V,'r', V,P_E08FR002./V,'r', V,P_E08FR003./V,'r', V,P_M10FR001./V,'m', V,P_M10FR002./V,'m', V,P_M10FR003./V,'m', V,P_E12FR001./V,'k', V,P_E12FR002./V,'k', V,P_E12FR003./V,'k', V,P_M12FR001./V,'k', V,P_M12FR002./V,'k', V,P_M12FR003./V,'k')
xlabel('Vazao [L/s]')
ylabel('Resistência [cmH2O/L/s]')
title('Resistências do TOT 8,5')
legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','Location','northwest')
