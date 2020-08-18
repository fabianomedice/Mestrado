clc
clear all
close all

for TOT_indice = 1:2
    for Sonda_indice = 1:4
        if TOT_indice == 1
            TOT = '7.5';
            if Sonda_indice == 1
                Sonda = 'E06';
                D0671 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D0672 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D0673 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            elseif Sonda_indice == 2
                Sonda = 'E08';
                D0871 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D0872 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D0873 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            elseif Sonda_indice == 3
                Sonda = 'M10';
                D1071 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D1072 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D1073 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            end
        elseif TOT_indice == 2
            TOT = '8.5';
            if Sonda_indice == 1
                Sonda = 'E06';
                D0681 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D0682 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D0683 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            elseif Sonda_indice == 2
                Sonda = 'E08';
                D0881 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D0882 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D0883 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            elseif Sonda_indice == 3
                Sonda = 'M10';
                D1081 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D1082 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D1083 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            elseif Sonda_indice == 4
                Sonda = 'E12';
                D1E81 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D1E82 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D1E83 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
                Sonda = 'M12';
                D1M81 = LeituraDados ([Sonda 'FR00' '1' '_TOT' TOT '_Vet.txt']);
                D1M82 = LeituraDados ([Sonda 'FR00' '2' '_TOT' TOT '_Vet.txt']);
                D1M83 = LeituraDados ([Sonda 'FR00' '3' '_TOT' TOT '_Vet.txt']);
            end
        end
    end
end


%Fazendo a Equação do RTOT
PressaoVent = 0:0.01:3.5;
% Vazao700 = 0.3833*abs(Pressao).^0.5872.*sign(Pressao);
Vazao706 = 0.3223*abs(PressaoVent).^0.5745.*sign(PressaoVent);
Vazao708 = 0.2745*abs(PressaoVent).^0.5687.*sign(PressaoVent);
Vazao710 = 0.2682*abs(PressaoVent).^0.5726.*sign(PressaoVent);
% Vazao800 = 0.548*abs(Pressao).^0.5688.*sign(Pressao);
Vazao806 = 0.4413*abs(PressaoVent).^0.5807.*sign(PressaoVent);
Vazao808 = 0.3795*abs(PressaoVent).^0.5819.*sign(PressaoVent);
Vazao810 = 0.3808*abs(PressaoVent).^0.5843.*sign(PressaoVent);
Vazao812 = 0.321*abs(PressaoVent).^0.5871.*sign(PressaoVent);

figure(1)
scatter(D0671.Flow_Ventilation,D0671.Pressure_Ventilation-D0671.Pressure_Lung,'b')
hold on
scatter(D0672.Flow_Ventilation,D0672.Pressure_Ventilation-D0672.Pressure_Lung,'b')
scatter(D0673.Flow_Ventilation,D0673.Pressure_Ventilation-D0673.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao706,PressaoVent,'r')
hold off
title('TOT 7.5 Sonda 06')



% % figure(1)
% % scatter(D0671.Pressure_Ventilation-D0671.Pressure_Lung,(D0671.Pressure_Ventilation-D0671.Pressure_Lung)./D0671.Flow_Ventilation,'b')
% % hold on
% % scatter(D0672.Pressure_Ventilation-D0672.Pressure_Lung,(D0672.Pressure_Ventilation-D0672.Pressure_Lung)./D0672.Flow_Ventilation,'b')
% % scatter(D0673.Pressure_Ventilation-D0673.Pressure_Lung,(D0673.Pressure_Ventilation-D0673.Pressure_Lung)./D0673.Flow_Ventilation,'b')
% % xlabel('Pressure [cmH2O]')
% % ylabel('Resistance [cmH2O/L/s]')
% % hold on
% % plot(Pressao,Pressao./Vazao706,'r')
% % hold off
% % title('TOT 7.5 Sonda 06')
% % 
% % X067=[D0671.Pressure_Ventilation-D0671.Pressure_Lung; D0672.Pressure_Ventilation-D0672.Pressure_Lung; D0673.Pressure_Ventilation-D0673.Pressure_Lung];
% % Y067=[D0671.Flow_Ventilation; D0672.Flow_Ventilation; D0673.Flow_Ventilation];
% % 
% % indice = zeros(size(Y067));
% % for i=1:length(Y067)
% %     if Y067(i)<0
% %         indice(i) = i;
% %     end
% % end
% % 
% % %Retira os zeros do indice
% % condicao = indice(:)==0;
% % indice(condicao,:) = [];
% % 
% % if (indice > 0)    
% %     %Retira os valores colocado pelo indice
% %     for k=1:1:length(indice)
% %         X067([indice(k)-k+1])=[]; %Remove o dado
% %         Y067([indice(k)-k+1])=[]; %Remove o dado
% %     end
% % end
% % 
% % figure(2)
% % scatter(abs(X067),abs(X067)./Y067,'b')
% % hold on
% % xlabel('Pressure [cmH2O]')
% % ylabel('Resistance [cmH2O/L/s]')
% % hold on
% % plot(Pressao,Pressao./Vazao706,'r')
% % hold off
% % title('TOT 7.5 Sonda 06')




figure(2)
scatter(D0871.Flow_Ventilation,D0871.Pressure_Ventilation-D0871.Pressure_Lung,'b')
hold on
scatter(D0872.Flow_Ventilation,D0872.Pressure_Ventilation-D0872.Pressure_Lung,'b')
scatter(D0873.Flow_Ventilation,D0873.Pressure_Ventilation-D0873.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao708,PressaoVent,'r')
hold off
title('TOT 7.5 Sonda 08')

figure(3)
scatter(D1071.Flow_Ventilation,D1071.Pressure_Ventilation-D1071.Pressure_Lung,'b')
hold on
scatter(D1072.Flow_Ventilation,D1072.Pressure_Ventilation-D1072.Pressure_Lung,'b')
scatter(D1073.Flow_Ventilation,D1073.Pressure_Ventilation-D1073.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao710,PressaoVent,'r')
hold off
title('TOT 7.5 Sonda 10')

% % figure(3)
% % scatter(D1071.Pressure_Ventilation-D1071.Pressure_Lung,D1071.Flow_Ventilation,'b')
% % hold on
% % scatter(D1072.Pressure_Ventilation-D1072.Pressure_Lung,D1072.Flow_Ventilation,'b')
% % scatter(D1073.Pressure_Ventilation-D1073.Pressure_Lung,D1073.Flow_Ventilation,'b')
% % xlabel('Pressure [cmH2O]')
% % ylabel('Flow [L/s]')
% % hold on
% % plot(Pressao,Vazao710,'r')
% % hold off
% % title('TOT 7.5 Sonda 10')
% % 
% % 
% % X107=[D1071.Pressure_Ventilation-D1071.Pressure_Lung; D1072.Pressure_Ventilation-D1072.Pressure_Lung; D1073.Pressure_Ventilation-D1073.Pressure_Lung];
% % Y107=[D1071.Flow_Ventilation; D1072.Flow_Ventilation; D1073.Flow_Ventilation];
% % 
% % indice = zeros(size(Y107));
% % for i=1:length(Y107)
% %     if Y107(i)<0
% %         indice(i) = i;
% %     end
% % end
% % 
% % %Retira os zeros do indice
% % condicao = indice(:)==0;
% % indice(condicao,:) = [];
% % 
% % if (indice > 0)    
% %     %Retira os valores colocado pelo indice
% %     for k=1:1:length(indice)
% %         X107([indice(k)-k+1])=[]; %Remove o dado
% %         Y107([indice(k)-k+1])=[]; %Remove o dado
% %     end
% % end


figure(4)
scatter(D0681.Flow_Ventilation,D0681.Pressure_Ventilation-D0681.Pressure_Lung,'b')
hold on
scatter(D0682.Flow_Ventilation,D0682.Pressure_Ventilation-D0682.Pressure_Lung,'b')
scatter(D0683.Flow_Ventilation,D0683.Pressure_Ventilation-D0683.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao806,PressaoVent,'r')
hold off
title('TOT 8.5 Sonda 06')

figure(5)
scatter(D0881.Flow_Ventilation,D0881.Pressure_Ventilation-D0881.Pressure_Lung,'b')
hold on
scatter(D0882.Flow_Ventilation,D0882.Pressure_Ventilation-D0882.Pressure_Lung,'b')
scatter(D0883.Flow_Ventilation,D0883.Pressure_Ventilation-D0883.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao808,PressaoVent,'r')
hold off
title('TOT 8.5 Sonda 08')

figure(6)
scatter(D1081.Flow_Ventilation,D1081.Pressure_Ventilation-D1081.Pressure_Lung,'b')
hold on
scatter(D1082.Flow_Ventilation,D1082.Pressure_Ventilation-D1082.Pressure_Lung,'b')
scatter(D1083.Flow_Ventilation,D1083.Pressure_Ventilation-D1083.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao810,PressaoVent,'r')
hold off
title('TOT 8.5 Sonda 10')

figure(7)
scatter(D1E81.Flow_Ventilation,D1E81.Pressure_Ventilation-D1E81.Pressure_Lung,'b')
hold on
scatter(D1E82.Flow_Ventilation,D1E82.Pressure_Ventilation-D1E82.Pressure_Lung,'b')
scatter(D1E83.Flow_Ventilation,D1E83.Pressure_Ventilation-D1E83.Pressure_Lung,'b')
scatter(D1M81.Flow_Ventilation,D1M81.Pressure_Ventilation-D1M81.Pressure_Lung,'b')
scatter(D1M82.Flow_Ventilation,D1M82.Pressure_Ventilation-D1M82.Pressure_Lung,'b')
scatter(D1M83.Flow_Ventilation,D1M83.Pressure_Ventilation-D1M83.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
hold on
plot(Vazao812,PressaoVent,'r')
hold off
title('TOT 8.5 Sonda 12')

% % figure(8)
% % plot(Vazao706,Pressao,'r--')
% % hold on
% % plot(Vazao708,Pressao,'b--')
% % plot(Vazao710,Pressao,'g--')
% % plot(Vazao806,Pressao,'r')
% % plot(Vazao808,Pressao,'b')
% % plot(Vazao810,Pressao,'g')
% % plot(Vazao812,Pressao,'k')
% % hold off
% % legend('TOT 7.5 Sonda 06','TOT 7.5 Sonda 08','TOT 7.5 Sonda 10','TOT 8.5 Sonda 06','TOT 8.5 Sonda 08','TOT 8.5 Sonda 10','TOT 8.5 Sonda 12')
% % xlabel('Flow [L/s]')
% % ylabel('Pressure [cmH2O]')

%Fazendo a Equação Rasp
PressaoAsp = -200:0.1:10;
Vazao06 =zeros(size(PressaoAsp));
Vazao08 =zeros(size(PressaoAsp));
Vazao10 =zeros(size(PressaoAsp));
Vazao12 =zeros(size(PressaoAsp));
for i=1:length(PressaoAsp)
    if PressaoAsp(i) >= 0
        Vazao06(i) = 0.001339*abs(PressaoAsp(i))^0.7939*sign(PressaoAsp(i));
    else
        Vazao06(i) = 0.002454*abs(PressaoAsp(i))^0.529*sign(PressaoAsp(i));
    end
    if PressaoAsp(i) >= 0
        Vazao08(i) = 0.01081*abs(PressaoAsp(i))^0.6338*sign(PressaoAsp(i));
    else
        Vazao08(i) = 0.01152*abs(PressaoAsp(i))^0.5948*sign(PressaoAsp(i));
    end

    if PressaoAsp(i) >= 0
        Vazao10(i) = 0.01501*abs(PressaoAsp(i))^0.6046*sign(PressaoAsp(i));
    else
        Vazao10(i) = 0.01614*abs(PressaoAsp(i))^0.5631*sign(PressaoAsp(i));
    end
    if PressaoAsp(i) >= 0
        Vazao12(i) = 0.03048*abs(PressaoAsp(i))^0.5689*sign(PressaoAsp(i));
    else
        Vazao12(i) = 0.03295*abs(PressaoAsp(i))^0.5183*sign(PressaoAsp(i));
    end
end

% Vazao06 = 0.001339*abs(PressaoAsp).^0.7939.*sign(PressaoAsp);
% Vazao08 = 0.01081*abs(PressaoAsp).^0.6338.*sign(PressaoAsp);
% Vazao10 = 0.01501*abs(PressaoAsp).^0.6046.*sign(PressaoAsp);
% Vazao12 = 0.03048*abs(PressaoAsp).^0.5689.*sign(PressaoAsp);

figure(9)
scatter(D0671.Flow_Suction,D0671.Pressure_Suction-D0671.Pressure_Lung,'b')
hold on
scatter(D0672.Flow_Suction,D0672.Pressure_Suction-D0672.Pressure_Lung,'b')
scatter(D0673.Flow_Suction,D0673.Pressure_Suction-D0673.Pressure_Lung,'b')
scatter(D0681.Flow_Suction,D0681.Pressure_Suction-D0681.Pressure_Lung,'b')
scatter(D0682.Flow_Suction,D0682.Pressure_Suction-D0682.Pressure_Lung,'b')
scatter(D0683.Flow_Suction,D0683.Pressure_Suction-D0683.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
plot(Vazao06,PressaoAsp,'r')
hold off
title('Sonda 06')
ylim([-200 10])
xlim([-0.2 0.1])

figure(10)
scatter(D0871.Flow_Suction,D0871.Pressure_Suction-D0871.Pressure_Lung,'b')
hold on
scatter(D0872.Flow_Suction,D0872.Pressure_Suction-D0872.Pressure_Lung,'b')
scatter(D0873.Flow_Suction,D0873.Pressure_Suction-D0873.Pressure_Lung,'b')
scatter(D0881.Flow_Suction,D0881.Pressure_Suction-D0881.Pressure_Lung,'b')
scatter(D0882.Flow_Suction,D0882.Pressure_Suction-D0882.Pressure_Lung,'b')
scatter(D0883.Flow_Suction,D0883.Pressure_Suction-D0883.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
plot(Vazao08,PressaoAsp,'r')
hold off
title('Sonda 08')
ylim([-80 10])
xlim([-0.2 0.1])

figure(11)
scatter(D1071.Flow_Suction,D1071.Pressure_Suction-D1071.Pressure_Lung,'b')
hold on
scatter(D1072.Flow_Suction,D1072.Pressure_Suction-D1072.Pressure_Lung,'b')
scatter(D1073.Flow_Suction,D1073.Pressure_Suction-D1073.Pressure_Lung,'b')
scatter(D1081.Flow_Suction,D1081.Pressure_Suction-D1081.Pressure_Lung,'b')
scatter(D1082.Flow_Suction,D1082.Pressure_Suction-D1082.Pressure_Lung,'b')
scatter(D1083.Flow_Suction,D1083.Pressure_Suction-D1083.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
plot(Vazao10,PressaoAsp,'r')
hold off
title('Sonda 10')
ylim([-60 10])
xlim([-0.2 0.1])

figure(12)
scatter(D1E81.Flow_Suction,D1E81.Pressure_Suction-D1E81.Pressure_Lung,'b')
hold on
scatter(D1E82.Flow_Suction,D1E82.Pressure_Suction-D1E82.Pressure_Lung,'b')
scatter(D1E83.Flow_Suction,D1E83.Pressure_Suction-D1E83.Pressure_Lung,'b')
scatter(D1M81.Flow_Suction,D1M81.Pressure_Suction-D1M81.Pressure_Lung,'b')
scatter(D1M82.Flow_Suction,D1M82.Pressure_Suction-D1M82.Pressure_Lung,'b')
scatter(D1M83.Flow_Suction,D1M83.Pressure_Suction-D1M83.Pressure_Lung,'b')
xlabel('Flow [L/s]')
ylabel('Pressure [cmH2O]')
plot(Vazao12,PressaoAsp,'r')
hold off
title('Sonda 12')
ylim([-25 10])
xlim([-0.2 0.1])