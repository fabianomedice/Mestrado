Delta_P = 0:0.1:25;

VazaoTraqueia = 0.06857*Delta_P.^0.3014;
Vazao700 = 0.3833*Delta_P.^0.5872;
Vazao706 = 0.3223*Delta_P.^0.5745;
Vazao708 = 0.2745*Delta_P.^0.5687;
Vazao710 = 0.2682*Delta_P.^0.5726;
Vazao800 = 0.548*Delta_P.^0.5688;
Vazao806 = 0.4413*Delta_P.^0.5807;
Vazao808 = 0.3795*Delta_P.^0.5819;
Vazao810 = 0.3808*Delta_P.^0.5843;
Vazao812 = 0.321*Delta_P.^0.5871;

figure
plot(Delta_P, Delta_P./VazaoTraqueia,'k-.')
hold on
plot(Delta_P, Delta_P./Vazao700,'k')
hold on
plot(Delta_P, Delta_P./Vazao706,'b')
plot(Delta_P, Delta_P./Vazao708,'r')
plot(Delta_P, Delta_P./Vazao710,'g')
plot(Delta_P, Delta_P./Vazao800,'k--')
plot(Delta_P, Delta_P./Vazao806,'b--')
plot(Delta_P, Delta_P./Vazao808,'r--')
plot(Delta_P, Delta_P./Vazao810,'g--')
plot(Delta_P, Delta_P./Vazao812,'m--')
xlabel('Diferença de Pressão [cmH2O]')
ylabel('Resistência [cmH2O/L/s]')
ylim([0,25])
legend('Traqueia','TOT 7.5','TOT 7.5 Sonda 06FR','TOT 7.5 Sonda 08FR','TOT 7.5 Sonda 10FR','TOT 8.5','TOT 8.5 Sonda 06FR','TOT 8.5 Sonda 08FR','TOT 8.5 Sonda 10FR','TOT 8.5 Sonda 12FR')

figure
plot(VazaoTraqueia, Delta_P./VazaoTraqueia,'k-.')
hold on
plot(Vazao700, Delta_P./Vazao700,'k')
hold on
plot(Vazao706, Delta_P./Vazao706,'b')
plot(Vazao708, Delta_P./Vazao708,'r')
plot(Vazao710, Delta_P./Vazao710,'g')
plot(Vazao800, Delta_P./Vazao800,'k--')
plot(Vazao806, Delta_P./Vazao806,'b--')
plot(Vazao808, Delta_P./Vazao808,'r--')
plot(Vazao810, Delta_P./Vazao810,'g--')
plot(Vazao812, Delta_P./Vazao812,'m--')
xlabel('Vazão Ventilação [L/s]')
ylabel('Resistência [cmH2O/L/s]')
ylim([0,15])
legend('Traqueia','TOT 7.5','TOT 7.5 Sonda 06FR','TOT 7.5 Sonda 08FR','TOT 7.5 Sonda 10FR','TOT 8.5','TOT 8.5 Sonda 06FR','TOT 8.5 Sonda 08FR','TOT 8.5 Sonda 10FR','TOT 8.5 Sonda 12FR')


figure
plot(Delta_P, Delta_P./Vazao700./(Delta_P./VazaoTraqueia),'k')
hold on
plot(Delta_P, Delta_P./Vazao706./(Delta_P./VazaoTraqueia),'b')
plot(Delta_P, Delta_P./Vazao708./(Delta_P./VazaoTraqueia),'r')
plot(Delta_P, Delta_P./Vazao710./(Delta_P./VazaoTraqueia),'g')
plot(Delta_P, Delta_P./Vazao800./(Delta_P./VazaoTraqueia),'k--')
plot(Delta_P, Delta_P./Vazao806./(Delta_P./VazaoTraqueia),'b--')
plot(Delta_P, Delta_P./Vazao808./(Delta_P./VazaoTraqueia),'r--')
plot(Delta_P, Delta_P./Vazao810./(Delta_P./VazaoTraqueia),'g--')
plot(Delta_P, Delta_P./Vazao812./(Delta_P./VazaoTraqueia),'m--')
xlabel('Diferença de Pressão [cmH2O]')
ylabel('Resistência / Resistência da Traqueia')
legend('TOT 7.5','TOT 7.5 Sonda 06FR','TOT 7.5 Sonda 08FR','TOT 7.5 Sonda 10FR','TOT 8.5','TOT 8.5 Sonda 06FR','TOT 8.5 Sonda 08FR','TOT 8.5 Sonda 10FR','TOT 8.5 Sonda 12FR')