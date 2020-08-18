clc
close all

%Pressão Estimada
P_06 = 0:0.001:75.7460; 
P_08 = 0:0.001:72.9890;
P_10 = 0:0.001:74.0720;
P_12 = 0:0.001:73.2890;
P_14 = 0:0.001:64.9960;

%Pressão Estimada para cftool
% P_06 = 0.00208:0.001:75.7460; 
% P_08 = 0.015:0.001:72.9890;
% P_10 = 0.015:0.001:74.0720;
% P_12 = 0.023:0.001:73.2890;
% P_14 = 0.026:0.001:64.9960;

%Vazões estimadas
V_E06FR001 = (0.001706*P_06.^0.7541-0.001724);
V_E06FR002 = (0.001766*P_06.^0.7334-0.001515);
V_E06FR003 = (0.001814*P_06.^0.733-0.002072);
V_E08FR001 = (0.01232*P_08.^0.5986-0.007618);
V_E08FR002 = (0.01873*P_08.^0.5453-0.01454);
V_E08FR003 = (0.01305*P_08.^0.5957-0.008032);
V_M10FR001 = (0.02026*P_10.^0.5486-0.01164);
V_M10FR002 = (0.02242*P_10.^0.5173-0.01485);
V_M10FR003 = (0.02102*P_10.^0.539-0.01185);
V_E12FR001 = (0.04066*P_12.^0.5041-0.02097);
V_E12FR002 = (0.03946*P_12.^0.5074-0.02061);
V_E12FR003 = (0.04029*P_12.^0.4984-0.02157);
V_M12FR001 = (0.04369*P_12.^0.5083-0.02214);
V_M12FR002 = (0.03787*P_12.^0.5274-0.01732);
V_M12FR003 = (0.04382*P_12.^0.514-0.01837);
V_M14FR001 = (0.06443*P_14.^0.5164-0.02396);
V_M14FR002 = (0.06064*P_14.^0.5194-0.02021);
V_M14FR003 = (0.06691*P_14.^0.5142-0.02526);

% figure
% plot(P_06,V_E06FR001,'b', P_06,V_E06FR002,'b', P_06,V_E06FR003,'b', P_08,V_E08FR001,'g', P_08,V_E08FR002,'g', P_08,V_E08FR003,'g', P_10,V_M10FR001,'r', P_10,V_M10FR002,'r', P_10,V_M10FR003,'r', P_12,V_E12FR001,'k', P_12,V_E12FR002, 'k',P_12,V_E12FR003,'k', P_12,V_M12FR001,'k', P_12,V_M12FR002,'k', P_12,V_M12FR003,'k', P_14,V_M14FR001,'m', P_14,V_M14FR002,'m', P_14,V_M14FR003,'m')
% xlabel('Pressão [cmH2O]')
% ylabel('Vazao [L/s]')
% legend('06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','14FR','14FR','14FR','Location','northeast')
% title('Vazão x Pressão das Sondas')

%Valores pra colocar no cftool para achar a equação POWER 2 média
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

V_06 = (0.00176*P_06.^0.7404-0.001768);
V_08 = (0.0146*P_08.^0.578-0.009949);
V_10 = (0.02119*P_10.^0.5352-0.01273);
V_12 = (0.04093*P_12.^0.5102-0.02012);
V_14 = (0.06399*P_14.^0.5166-0.02314);

figure
plot(P_06,V_E06FR001,':b', P_06,V_E06FR002,':b', P_06,V_E06FR003,':b',P_06,V_06,'b',P_08,V_E08FR001,':g', P_08,V_E08FR002,':g', P_08,V_E08FR003,':g',P_08,V_08,'g', P_10,V_M10FR001,':r', P_10,V_M10FR002,':r', P_10,V_M10FR003,':r',P_10,V_10,'r', P_12,V_E12FR001,':k', P_12,V_E12FR002,':k',P_12,V_E12FR003,':k', P_12,V_M12FR001,':k', P_12,V_M12FR002,':k', P_12,V_M12FR003,':k',P_12,V_12,'k', P_14,V_M14FR001,':m', P_14,V_M14FR002,':m', P_14,V_M14FR003,':m',P_14,V_14,'m')
xlabel('Pressão [cmH2O]')
ylabel('Vazao [L/s]')
legend('06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','12FR','12FR','12FR','12FR','12FR','12FR','12FR Médio','14FR','14FR','14FR','14FR Médio','Location','northeast')
title('Vazão x Pressão das Sondas')

%Pressão Estimada
P_TOT7_5 = 0:0.001:84.8320;

%Pressão Estimada para cftool
% P_TOT7_5 = 0.216:0.001:84.8320;

%Vazões estimadas para TOT 7,5
V_Sem_Sonda = (0.6262*P_TOT7_5.^0.4761-0.361);
V_E06FR001 = (0.4544*P_TOT7_5.^0.5023-0.2159);
V_E06FR002 = (0.4344*P_TOT7_5.^0.5088-0.1866);
V_E06FR003 = (0.4423*P_TOT7_5.^0.5092-0.1991);
V_E08FR001 = (0.3731*P_TOT7_5.^0.5046-0.1864);
V_E08FR002 = (0.3637*P_TOT7_5.^0.5109-0.1724);
V_E08FR003 = (0.3721*P_TOT7_5.^0.5116-0.1674);
V_M10FR001 = (0.3288*P_TOT7_5.^0.5368-0.1348);
V_M10FR002 = (0.4033*P_TOT7_5.^0.4842-0.2085);
V_M10FR003 = (0.3505*P_TOT7_5.^0.5202-0.1673);


% figure
% plot(P_TOT7_5,V_Sem_Sonda,'b', P_TOT7_5,V_E06FR001,'g', P_TOT7_5,V_E06FR002,'g', P_TOT7_5,V_E06FR003,'g', P_TOT7_5,V_E08FR001,'r', P_TOT7_5,V_E08FR002,'r', P_TOT7_5,V_E08FR003,'r', P_TOT7_5,V_M10FR001,'k', P_TOT7_5,V_M10FR002,'k', P_TOT7_5,V_M10FR003,'k')
% xlabel('Vazao [L/s]')
% ylabel('Resistência [cmH2O/L/s]')
% title('Resistências do TOT 7,5')
% legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','Location','northwest')

%Valores pra colocar no cftool para achar a equação POWER 2 média
% x = [P_TOT7_5 P_TOT7_5 P_TOT7_5];
% y06 = [V_E06FR001 V_E06FR002 V_E06FR003];
% y08 = [V_E08FR001 V_E08FR002 V_E08FR003];
% y10 = [V_M10FR001 V_M10FR002 V_M10FR003];

V_06 = (0.4436*P_TOT7_5.^0.5068-0.2005);
V_08 = (0.3696*P_TOT7_5.^0.5091-0.1753);
V_10 = (0.3586*P_TOT7_5.^0.5142-0.1676);

figure
plot(P_TOT7_5,V_Sem_Sonda,'b', P_TOT7_5,V_E06FR001,':g', P_TOT7_5,V_E06FR002,':g', P_TOT7_5,V_E06FR003,':g',P_TOT7_5,V_06,'g', P_TOT7_5,V_E08FR001,':r', P_TOT7_5,V_E08FR002,':r', P_TOT7_5,V_E08FR003,':r',P_TOT7_5,V_08,'r', P_TOT7_5,V_M10FR001,':k', P_TOT7_5,V_M10FR002,':k', P_TOT7_5,V_M10FR003,':k',P_TOT7_5,V_10,'k')
xlabel('Pressão [cmH2O]')
ylabel('Vazao [L/s]')
title('Vazão x Pressão do TOT 7.5 com as Sondas')
legend('Sem Sonda','06FR','06FR','06FR','06FR Médio','08FR','08FR','08FR','08FR Médio','10FR','10FR','10FR','10FR Médio','Location','northwest')

 
%Pressão Estimada
P_TOT8_5 = 0:0.001:85.7550;

%Pressão Estimada para cftool
% P_TOT8_5 = 0.279:0.001:85.7550;

%Vazões estimadas para TOT 8,5
V_Sem_Sonda = (0.8354*P_TOT8_5.^0.4751-0.4316);
V_E06FR001 = (0.5864*P_TOT8_5.^0.5188-0.2399);
V_E06FR002 = (0.5926*P_TOT8_5.^0.5162-0.2376);
V_E06FR003 = (0.6109*P_TOT8_5.^0.5113-0.2787);
V_E08FR001 = (0.4899*P_TOT8_5.^0.5252-0.2051);
V_E08FR002 = (0.5168*P_TOT8_5.^0.5164-0.2377);
V_E08FR003 = (0.5331*P_TOT8_5.^0.5122-0.2319);
V_M10FR001 = (0.5114*P_TOT8_5.^0.5186-0.229);
V_M10FR002 = (0.5305*P_TOT8_5.^0.5114-0.2301);
V_M10FR003 = (0.5271*P_TOT8_5.^0.515-0.226);
V_E12FR001 = (0.3965*P_TOT8_5.^0.5402-0.1468);
V_E12FR002 = (0.4112*P_TOT8_5.^0.5358-0.177);
V_E12FR003 = (0.4445*P_TOT8_5.^0.5227-0.1849);
V_M12FR001 = (0.4672*P_TOT8_5.^0.5123-0.209);
V_M12FR002 = (0.385*P_TOT8_5.^0.5349-0.1541);
V_M12FR003 = (0.4253*P_TOT8_5.^0.533-0.167);


% figure
% plot(P_TOT8_5,V_Sem_Sonda,'b', P_TOT8_5,V_E06FR001,'g', P_TOT8_5,V_E06FR002,'g', P_TOT8_5,V_E06FR003,'g', P_TOT8_5,V_E08FR001,'r', P_TOT8_5,V_E08FR002,'r', P_TOT8_5,V_E08FR003,'r', P_TOT8_5,V_M10FR001,'m', P_TOT8_5,V_M10FR002,'m', P_TOT8_5,V_M10FR003,'m', P_TOT8_5,V_E12FR001,'k', P_TOT8_5,V_E12FR002,'k', P_TOT8_5,V_E12FR003,'k', P_TOT8_5,V_M12FR001,'k', P_TOT8_5,V_M12FR002,'k', P_TOT8_5,V_M12FR003,'k')
% xlabel('Pressão [cmH2O]')
% ylabel('Vazao [L/s]')
% title('Vazão x Pressão do TOT 8.5 com as Sondas')
% legend('Sem Sonda','06FR','06FR','06FR','08FR','08FR','08FR','10FR','10FR','10FR','12FR','12FR','12FR','12FR','12FR','12FR','Location','northwest')

% Valores pra colocar no cftool para achar a equação POWER 2 média
% x = [P_TOT8_5 P_TOT8_5 P_TOT8_5];
% y06 = [V_E06FR001 V_E06FR002 V_E06FR003];
% y08 = [V_E08FR001 V_E08FR002 V_E08FR003];
% y10 = [V_M10FR001 V_M10FR002 V_M10FR003];
% x12 = [P_TOT8_5 P_TOT8_5 P_TOT8_5 P_TOT8_5 P_TOT8_5 P_TOT8_5];
% y12 = [V_E12FR001 V_E12FR002 V_E12FR003 V_M12FR001 V_M12FR002 V_M12FR003];

V_06 = (0.5966*P_TOT8_5.^0.5154-0.252);
V_08 = (0.5131*P_TOT8_5.^0.5179-0.2247);
V_10 = (0.5229*P_TOT8_5.^0.515-0.2283);
V_12 = (0.4211*P_TOT8_5.^0.5297-0.1726);

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
title('Resistências das Sondas com constante')
ylim([-5 20])