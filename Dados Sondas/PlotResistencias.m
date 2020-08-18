clc
clear all
close all

P = -70:1:70;
Vazao06 = zeros(1,length(P));
Vazao08 = zeros(1,length(P));
Vazao10 = zeros(1,length(P));
Vazao12 = zeros(1,length(P));
Vazao7_5 = zeros(1,length(P));
Vazao7_5_06 = zeros(1,length(P));
Vazao7_5_08 = zeros(1,length(P));
Vazao7_5_10 = zeros(1,length(P));
Vazao8_5 = zeros(1,length(P));
Vazao8_5_06 = zeros(1,length(P));
Vazao8_5_08 = zeros(1,length(P));
Vazao8_5_10 = zeros(1,length(P));
Vazao8_5_12 = zeros(1,length(P));

for i=1:length(P)
    if P(i) >= 0
        Vazao06(i) = 0.001339*P(i)^0.7939;
        Vazao08(i) = 0.01081*P(i)^0.6338;
        Vazao10(i) = 0.01501*P(i)^0.6046;
        Vazao12(i) = 0.03048*P(i)^0.5689;
        Vazao7_5(i) = 0.3833*P(i)^0.5872;
        Vazao7_5_06(i) = 0.3223*P(i)^0.5745;
        Vazao7_5_08(i) = 0.2745*P(i)^0.5687;
        Vazao7_5_10(i) = 0.2682*P(i)^0.5726;
        Vazao8_5(i) = 0.548*P(i)^0.5688;
        Vazao8_5_06(i) = 0.4413*P(i)^0.5807;
        Vazao8_5_08(i) = 0.3795*P(i)^0.5819;
        Vazao8_5_10(i) = 0.3808*P(i)^0.5843;
        Vazao8_5_12(i) = 0.321*P(i)^0.5871;
    else
        Vazao06(i) = -0.002454*abs(P(i))^0.529;
        Vazao08(i) = -0.01152*abs(P(i))^0.5948;
        Vazao10(i) = -0.01614*abs(P(i))^0.5631;
        Vazao12(i) = -0.03295*abs(P(i))^0.5183;
        Vazao7_5(i) = -0.3666*abs(P(i))^0.5487;
        Vazao7_5_06(i) = -0.3054*abs(P(i))^0.5543;
        Vazao7_5_08(i) = -0.2548*abs(P(i))^0.5561;
        Vazao7_5_10(i) = -0.244*abs(P(i))^0.5523;
        Vazao8_5(i) = -0.5163*abs(P(i))^0.5305;
        Vazao8_5_06(i) = -0.4154*abs(P(i))^0.5409;
        Vazao8_5_08(i) = -0.3653*abs(P(i))^0.5514;
        Vazao8_5_10(i) = -0.3602*abs(P(i))^0.5391;
        Vazao8_5_12(i) = -0.2907*abs(P(i))^0.54;
    end    
end

subplot(1,2,1)
plot(P,P./Vazao06,'r',P,P./Vazao08,'b',P,P./Vazao10,'g',P,P./Vazao12,'m')
legend('Sonda 06FR','Sonda 08FR','Sonda 10FR','Sonda 12FR')
xlabel('Diferença de Pressão [cmH2O]')
ylabel('Resistência [cmH2O/L/s]')

subplot(1,2,2)
plot(P,P./Vazao7_5,'k',P,P./Vazao7_5_06,'r',P,P./Vazao7_5_08,'b',P,P./Vazao7_5_10,'g',P,P./Vazao8_5,'k--',P,P./Vazao8_5_06,'r--',P,P./Vazao8_5_08,'b--',P,P./Vazao8_5_10,'g--',P,P./Vazao8_5_12,'m--')
legend('TOT 7,5 sem sonda','TOT 7,5 com sonda 06FR','TOT 7,5 com sonda 08FR','TOT 7,5 com sonda 10FR','TOT 8,5 sem sonda','TOT 8,5 com sonda 06FR','TOT 8,5 com sonda 08FR','TOT 8,5 com sonda 10FR','TOT 8,5 com sonda 12FR')
xlabel('Diferença de Pressão [cmH2O]')
ylabel('Resistência [cmH2O/L/s]')