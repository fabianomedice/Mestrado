close all

figure
plot(VazaoEq2)
hold on
plot(VazaoEq3)
hold off
legend ('Vazao da Eq2','Vazao da Eq3')
xlabel ('Tempo (s)')
ylabel ('Vazao (L/s)')
xlim([-0.1 5.1])
ylim([-1.2 0.2])

figure
plot(VolumeEq2)
hold on
plot(VolumeEq3)
hold off
legend ('Volume da Eq2','Volume da Eq3')
xlabel ('Tempo (s)')
ylabel ('Volume (L)')

figure
plot(PressaoEq2)
hold on
plot(PressaoEq3)
hold off
legend ('Pressao da Eq2','Pressao da Eq3')
xlabel ('Tempo (s)')
ylabel ('Pressao (cmH20)')