%shuntpot.m -- simulates the gain calibration with a digital pot:
%
%    exres    baseres
%   /\/\/-----/\/\/-----------------  Vout
%                    /             /
%                    \ shuntres    \ potres
%                    /             /
%                    \             \
%                     --------------
%		            GND


%call topres = exres + baseres, and botres = shuntres || potres
%atten is botres/(topres+botres)

%potres is a digital pot, with rwa being the top and rwb being the bottom
%resistors.  Ca is the capacitance between the wiper (ground) and the top
%of rwa (the voltage output).

%rwa is the resistor closer to the signal, and rwb is the resistor closer
%to ground within the pot


clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Choose the top resistors and desired attenuation ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%exres = 100;
%exres = 200;
exres = 0;


baseres = 100;

topres = exres+baseres;

desired_ratio = 0.95;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pot details
%
%The ad5262 is a dual 20k pot with 256 steps
%30% tolerance on resistor value
%Ca is the capacitance of the pot input and output to ground
%Cw is the wiper capacitance to ground
%
%Choose the shunt resistor value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shuntres = 4000;

bigpot_nom = 20e3;	%Potentiometer body resistance
bigpot_tol = 0.3;	%Potentiometer body tolerance
bigpot_high = bigpot_nom*(1+bigpot_tol);
bigpot_low = bigpot_nom*(1-bigpot_tol);
Ca = 25e-12;
Cw = 55e-12;
potsteps = 256;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the bottom resistor (botres) for each pot setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha = linspace(0,1,potsteps);
ytot = 1/shuntres+1./(alpha*bigpot_nom);
botres_nom = 1./ytot;

ytot = 1/shuntres+1./(alpha*bigpot_high);
botres_high = 1./ytot;

ytot = 1/shuntres+1./(alpha*bigpot_low);
botres_low = 1./ytot;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the divider ratio for each pot setting, find how many
%settings will give the desired ratio within 5%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ratio_nom = botres_nom./(topres+botres_nom);
ratio_high = botres_high./(topres+botres_high);
ratio_low = botres_low./(topres+botres_low);
indexes = find(ratio_nom>(desired_ratio*.95)&ratio_nom<(desired_ratio*1.05));
if size(indexes,2) == 0,
	disp('No valid resistor settings -- change topres');
	break;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find where the ratios begin to be within 0.2% of each other
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count = 2;
ratio_too_big = 1;
while ratio_too_big==1,
	increment_ratio = ratio_high(count+1)/ratio_high(count)-1;
	ratio_too_big = increment_ratio>0.002;
	endcount = count;
	count = count+1;
end
bottom_ratio = ratio_high(endcount);
end_ratio = ratio_low(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the attenuator bandwidth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outy = 1/topres+1./botres_nom(indexes(end));	%The end will be the biggest bottom resistor
outr = 1./outy;	%The output resistance disregarding the shunt capacitance
fcorner = 1/(6.28*outr*Ca);


strone = num2str(size(indexes,2));
strtwo = 'Settings within 5 percent of desired ratio';
disp([strone ' ' strtwo]);

strtwo = num2str(fcorner/1e6);
strone = 'Bandwidth is';
disp([strone ' ' strtwo  ' ' 'MHz']);

strtwo = num2str(bottom_ratio);
strzero = num2str(end_ratio);
strone = 'Increment ratios better than 0.2% from ';
disp([strone strtwo ' to ' strzero]);

graphics_toolkit('gnuplot');

figure(1);
plot(alpha*potsteps,ratio_nom,'@',alpha*potsteps,ratio_low,'@',alpha*potsteps,ratio_high,'@',alpha*potsteps,zeros(1,size(alpha,2))+bottom_ratio,';Lowest reliable setting for 0.2% accuracy;',alpha*potsteps,zeros(1,size(alpha,2))+end_ratio,';Highest reliable setting for 0.2% accuracy;');
%axis([0 potsteps 0.9 0.94]);
%axis([0 potsteps 0.8 0.85]);
axis([0 potsteps desired_ratio*.9 desired_ratio*1.1]);
xlabel('Resistor position');
ylabel('Divider ratio');
%plot(alpha(indexes),ratio(indexes),'@');
pause;
break

figure(2);
axis;
plot(alpha(indexes)*potsteps,botres(indexes),'@');
xlabel('Resistor position');
ylabel('Pot value');


