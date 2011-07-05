%offpot.m
%Simulates a pot used to provide offset for a differential amplifier

%The top of the pot is connected to Vcc_plus, the bottom to Vcc_minus
%potres is the resistance of the potentiometer body
%
%topres is the resistance above the wiper, botres that below it within
%the pot.
%
%shuntres is the small resistor to ground shunting the wiper output
%wipres is the wiper series resistance

clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ad5260 specs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%256 positions
%+/- 5.5V power
%Wiper resistance ~100 ohms
%20 kohm body resistance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Digital pot specs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Vcc_plus = 5;
Vcc_minus = -5;
potres = 20e3;
potsteps = 256;
int_wip_res = 100; %Wiper resistance internal to the pot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%External parts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shuntres = 10;
wipres =8e3;
ext_topres = 3e3;	%External resistances used to lower the maximum pot voltages
ext_botres = 3e3;

increment_tol = 30e-6;	%Volts -- program will find the pot positions where increment is below this



alpha = linspace(0,1,potsteps);
botres = potres*alpha+ext_botres;	
topres = potres*(1-alpha)+ext_topres;

Vadj = Vcc_plus*(shuntres)./(topres+wipres+int_wip_res+shuntres)+Vcc_minus*(shuntres)./(botres+wipres+int_wip_res+shuntres);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find where adjustment increment is below tolerance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for count = 1:(potsteps-1)
	increment(count) = Vadj(count+1)-Vadj(count);
end
range_indexes = find(increment<=increment_tol);
Vadj_low = Vadj(min(range_indexes));
Vadj_high = Vadj(max(range_indexes));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('*****************************************');
strone = num2str(Vadj_low*1000);
strtwo = num2str(Vadj_high*1000);
strfour = num2str(increment_tol*1e6)
strthree = 'Increment less than ';
disp([strthree strfour 'uV from ' strone ' to ' strtwo ' mV']);



plot(alpha,Vadj*1e3,'@;Output voltages;',alpha,zeros(1,size(alpha,2))+Vadj_low*1000,';Minimum precision voltage;',alpha,zeros(1,size(alpha,2))+Vadj_high*1000,';Maximum precision voltage;');
ylabel('Adjustment voltage (mV)');
xlabel('Pot setting (fraction)');
%gset xrange [.25:.75];
replot
