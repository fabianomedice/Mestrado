clc
% close all

%Pressão Estimada
P_06 = 0:0.001:75.7460; 
P_08 = 0:0.001:72.9890;
P_10 = 0:0.001:74.0720;
P_12 = 0:0.001:73.2890;
P_14 = 0:0.001:64.9960;

% %Pressão Estimada para cftool
% P_06 = 0.001:0.001:75.7460; 
% P_08 = 0.001:0.001:72.9890;
% P_10 = 0.001:0.001:74.0720;
% P_12 = 0.001:0.001:73.2890;
% P_14 = 0.001:0.001:64.9960;

%Vazões estimadas
V_E06FR001 = (0.001231*P_06.^0.8241);
V_E06FR002 = (0.001362*P_06.^0.7862);
V_E06FR003 = (0.001193*P_06.^0.8241);
V_E08FR001 = (0.009048*P_08.^0.6629);
V_E08FR002 = (0.01212*P_08.^0.633);
V_E08FR003 = (0.009665*P_08.^0.6576);
V_M10FR001 = (0.01477*P_10.^0.6127);
V_M10FR002 = (0.01503*P_10.^0.5977);
V_M10FR003 = (0.01521*P_10.^0.6048);
V_E12FR001 = (0.02958*P_12.^0.5677);
V_E12FR002 = (0.02841*P_12.^0.5742);
V_E12FR003 = (0.02871*P_12.^0.5668);
V_M12FR001 = (0.032*P_12.^0.5709);
V_M12FR002 = (0.02902*P_12.^0.5813);
V_M12FR003 = (0.03392*P_12.^0.5664);
V_M14FR001 = (0.05172*P_14.^0.5608);
V_M14FR002 = (0.0496*P_14.^0.561);
V_M14FR003 = (0.0529*P_14.^0.5624);

% figure
% plot(P_06,V_E06FR001,'b', P_06,V_E06FR002,'b', P_06,V_E06FR003,'b', P_08,V_E08FR001,'g', P_08,V_E08FR002,'g', P_08,V_E08FR003,'g', P_10,V_M10FR001,'r', P_10,V_M10FR002,'r', P_10,V_M10FR003,'r', P_12,V_E12FR001,'k', P_12,V_E12FR002, 'k',P_12,V_E12FR003,'k', P_12,V_M12FR001,'k', P_12,V_M12FR002,'k', P_12,V_M12FR003,'k', P_14,V_M14FR001,'m', P_14,V_M14FR002,'m', P_14,V_M14FR003,'m')
% xlabel('Pressão [cmH2O]')
% ylabel('Vazao [L/s]')
% legend('06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','14FR','14FR','14FR','Location','northeast')
% title('Vazão x Pressão das Sondas')
% 
% % Valores pra colocar no cftool para achar a equação POWER 1 média
% x06 = [P_06 P_06 P_06];
% y06 = [V_E06FR001 V_E06FR002 V_E06FR003];
% x08 = [P_08 P_08 P_08];
% y08 = [V_E08FR001 V_E08FR002 V_E08FR003];
% x10 = [P_10 P_10 P_10];
% y10 = [V_M10FR001 V_M10FR002 V_M10FR003];
% x12 = [P_12 P_12 P_12 P_12 P_12 P_12];
% y12 = [V_E12FR001 V_E12FR002 V_E12FR003 V_M12FR001 V_M12FR002 V_M12FR003];
% x14 = [P_14 P_14 P_14];
% y14 = [V_M14FR001 V_M14FR002 V_M14FR003];

V_06 = (0.001259*P_06.^0.8116);
V_08 = (0.01027*P_08.^0.6501);
V_10 = (0.015*P_10.^0.6051);
V_12 = (0.03027*P_12.^0.5712);
V_14 = (0.05141*P_14.^0.5614);

figure
plot(P_06,V_E06FR001,':b', P_06,V_E06FR002,':b', P_06,V_E06FR003,':b',P_06,V_06,'b',P_08,V_E08FR001,':g', P_08,V_E08FR002,':g', P_08,V_E08FR003,':g',P_08,V_08,'g', P_10,V_M10FR001,':r', P_10,V_M10FR002,':r', P_10,V_M10FR003,':r',P_10,V_10,'r', P_12,V_E12FR001,':k', P_12,V_E12FR002,':k',P_12,V_E12FR003,':k', P_12,V_M12FR001,':k', P_12,V_M12FR002,':k', P_12,V_M12FR003,':k',P_12,V_12,'k', P_14,V_M14FR001,':m', P_14,V_M14FR002,':m', P_14,V_M14FR003,':m',P_14,V_14,'m')
xlabel('Pressão [cmH2O]')
ylabel('Vazao [L/s]')
legend('06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','12FR','12FR','12FR','12FR','12FR','12FR','12FR Médio','14FR','14FR','14FR','14FR Médio','Location','northeast')
title('Vazão x Pressão das Sondas')

%Pressão Estimada
P_TOT7_5 = 0:0.001:84.8320;

% % %Pressão Estimada para cftool
% % P_TOT7_5 = 0.001:0.001:84.8320;

%Vazões estimadas para TOT 7,5
V_Sem_Sonda = (0.3833*P_TOT7_5.^0.5872);
V_E06FR001 = (0.3249*P_TOT7_5.^0.5728);
V_E06FR002 = (0.3215*P_TOT7_5.^0.5725);
V_E06FR003 = (0.3223*P_TOT7_5.^0.5765);
V_E08FR001 = (0.267*P_TOT7_5.^0.573);
V_E08FR002 = (0.2694*P_TOT7_5.^0.5712);
V_E08FR003 = (0.2782*P_TOT7_5.^0.5712);
V_M10FR001 = (0.2606*P_TOT7_5.^0.5833);
V_M10FR002 = (0.2867*P_TOT7_5.^0.5514);
V_M10FR003 = (0.2606*P_TOT7_5.^0.5801);


% figure
% plot(P_TOT7_5,V_Sem_Sonda,'b', P_TOT7_5,V_E06FR001,'g', P_TOT7_5,V_E06FR002,'g', P_TOT7_5,V_E06FR003,'g', P_TOT7_5,V_E08FR001,'r', P_TOT7_5,V_E08FR002,'r', P_TOT7_5,V_E08FR003,'r', P_TOT7_5,V_M10FR001,'k', P_TOT7_5,V_M10FR002,'k', P_TOT7_5,V_M10FR003,'k')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% title('Resistências do TOT 7,5')
% legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','Location','northwest')

% % % % % Valores pra colocar no cftool para achar a equação POWER 1 média
% % % % x = [P_TOT7_5 P_TOT7_5 P_TOT7_5];
% % % % y06 = [V_E06FR001 V_E06FR002 V_E06FR003];
% % % % y08 = [V_E08FR001 V_E08FR002 V_E08FR003];
% % % % y10 = [V_M10FR001 V_M10FR002 V_M10FR003];

V_06 = (0.3229*P_TOT7_5.^0.5739);
V_08 = (0.2715*P_TOT7_5.^0.5718);
V_10 = (0.269*P_TOT7_5.^0.5717);

figure
plot(P_TOT7_5,V_Sem_Sonda,'b', P_TOT7_5,V_E06FR001,':g', P_TOT7_5,V_E06FR002,':g', P_TOT7_5,V_E06FR003,':g',P_TOT7_5,V_06,'g', P_TOT7_5,V_E08FR001,':r', P_TOT7_5,V_E08FR002,':r', P_TOT7_5,V_E08FR003,':r',P_TOT7_5,V_08,'r', P_TOT7_5,V_M10FR001,':k', P_TOT7_5,V_M10FR002,':k', P_TOT7_5,V_M10FR003,':k',P_TOT7_5,V_10,'k')
xlabel('Pressão [cmH2O]')
ylabel('Vazao [L/s]')
title('Vazão x Pressão do TOT 7.5 com as Sondas')
legend('Sem Sonda','06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','Location','northwest')

 
%Pressão Estimada
P_TOT8_5 = 0:0.001:85.7550;

%Pressão Estimada para cftool
% P_TOT8_5 = 0.001:0.001:85.7550;

%Vazões estimadas para TOT 8,5
V_Sem_Sonda = (0.548*P_TOT8_5.^0.5688);
V_E06FR001 = (0.4365*P_TOT8_5.^0.584);
V_E06FR002 = (0.4414*P_TOT8_5.^0.5813);
V_E06FR003 = (0.4445*P_TOT8_5.^0.5781);
V_E08FR001 = (0.3681*P_TOT8_5.^0.5869);
V_E08FR002 = (0.3794*P_TOT8_5.^0.5807);
V_E08FR003 = (0.3913*P_TOT8_5.^0.5784);
V_M10FR001 = (0.3703*P_TOT8_5.^0.5895);
V_M10FR002 = (0.3866*P_TOT8_5.^0.5804);
V_M10FR003 = (0.3866*P_TOT8_5.^0.5823);
V_E12FR001 = (0.3132*P_TOT8_5.^0.5904);
V_E12FR002 = (0.3141*P_TOT8_5.^0.5918);
V_E12FR003 = (0.3359*P_TOT8_5.^0.5821);
V_M12FR001 = (0.3459*P_TOT8_5.^0.5744);
V_M12FR002 = (0.2955*P_TOT8_5.^0.5915);
V_M12FR003 = (0.326*P_TOT8_5.^0.5905);


% figure
% plot(P_TOT8_5,V_Sem_Sonda,'b', P_TOT8_5,V_E06FR001,'g', P_TOT8_5,V_E06FR002,'g', P_TOT8_5,V_E06FR003,'g', P_TOT8_5,V_E08FR001,'r', P_TOT8_5,V_E08FR002,'r', P_TOT8_5,V_E08FR003,'r', P_TOT8_5,V_M10FR001,'m', P_TOT8_5,V_M10FR002,'m', P_TOT8_5,V_M10FR003,'m', P_TOT8_5,V_E12FR001,'k', P_TOT8_5,V_E12FR002,'k', P_TOT8_5,V_E12FR003,'k', P_TOT8_5,V_M12FR001,'k', P_TOT8_5,V_M12FR002,'k', P_TOT8_5,V_M12FR003,'k')
% xlabel('Pressão [cmH2O]')
% ylabel('Vazao [L/s]')
% title('Vazão x Pressão do TOT 8.5 com as Sondas')
% legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','Location','northwest')

% Valores pra colocar no cftool para achar a equação POWER 1 média
x = [P_TOT8_5 P_TOT8_5 P_TOT8_5];
y06 = [V_E06FR001 V_E06FR002 V_E06FR003];
y08 = [V_E08FR001 V_E08FR002 V_E08FR003];
y10 = [V_M10FR001 V_M10FR002 V_M10FR003];
x12 = [P_TOT8_5 P_TOT8_5 P_TOT8_5 P_TOT8_5 P_TOT8_5 P_TOT8_5];
y12 = [V_E12FR001 V_E12FR002 V_E12FR003 V_M12FR001 V_M12FR002 V_M12FR003];

V_06 = (0.4408*P_TOT8_5.^0.5811);
V_08 = (0.3796*P_TOT8_5.^0.582);
V_10 = (0.3811*P_TOT8_5.^0.584);
V_12 = (0.3217*P_TOT8_5.^0.5867);

figure
plot(P_TOT8_5,V_Sem_Sonda,'b', P_TOT8_5,V_E06FR001,':g', P_TOT8_5,V_E06FR002,':g', P_TOT8_5,V_E06FR003,':g',P_TOT8_5,V_06,'g', P_TOT8_5,V_E08FR001,':r', P_TOT8_5,V_E08FR002,':r', P_TOT8_5,V_E08FR003,':r',P_TOT8_5,V_08,'r', P_TOT8_5,V_M10FR001,':k', P_TOT8_5,V_M10FR002,':k', P_TOT8_5,V_M10FR003,':k',P_TOT8_5,V_10,'k', P_TOT8_5,V_E12FR001,':m', P_TOT8_5,V_E12FR002,':m', P_TOT8_5,V_E12FR003,':m', P_TOT8_5,V_M12FR001,':m', P_TOT8_5,V_M12FR002,':m', P_TOT8_5,V_M12FR003,':m',P_TOT8_5,V_12,'m')
xlabel('Pressão [cmH2O]')
ylabel('Vazao [L/s]')
title('Vazão x Pressão do TOT 8.5 com as Sondas')
legend('Sem Sonda','06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','12FR','12FR','12FR','12FR','12FR','12FR','12FR Médio','Location','northwest')

%teste
figure
plot(P_TOT8_5,P_TOT8_5./V_Sem_Sonda)
xlabel('Pressão [cmH2O]')
ylabel('Resistência [cmH2O/L/s]')
title('Resistências das Sondas sem constante')
ylim([-5 20])