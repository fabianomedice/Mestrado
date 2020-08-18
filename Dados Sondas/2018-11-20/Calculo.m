clc
clear all

[X,Y]=VazaoPressao('TOT7,5_2018_11_14.tdms');

% [X1,Y1]=VazaoPressao('M10FR001_2018_11_14.tdms');
% [X2,Y2]=VazaoPressao('M10FR002_2018_11_14.tdms');
% [X3,Y3]=VazaoPressao('M10FR003_2018_11_14.tdms');
% 
% X = [X1 X2 X3];
% Y = [Y1 Y2 Y3];

% % [X1,Y1]=VazaoPressao('E12FR001_2018_11_14.tdms');
% % [X2,Y2]=VazaoPressao('E12FR002_2018_11_14.tdms');
% % [X3,Y3]=VazaoPressao('E12FR003_2018_11_14.tdms');
% % [X4,Y4]=VazaoPressao('M12FR001_2018_11_14.tdms');
% % [X5,Y5]=VazaoPressao('M12FR002_2018_11_14.tdms');
% % [X6,Y6]=VazaoPressao('M12FR003_2018_11_14.tdms');
% % 
% % X = [X1 X2 X3 X4 X5 X6];
% % Y = [Y1 Y2 Y3 Y4 Y5 Y6];

cftool (abs(X),abs(Y))