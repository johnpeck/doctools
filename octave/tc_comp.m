%Vbe_temp.m
%Plots calculated diode temperatures given a list of Vbe values.  Allows
%for nonideality and series resistance influences
clear;
close all;


%Data into a 1ohm load with 8.7V supply rails.  Vdig is 5.04V
currents = [1e-3 0.1 0.2 0.3 0.35];		%amps
vbe_one = 1e-3*[737 701 659 619 595];	%volts
vbe_two = 1e-3*[778 744 706 669 648];	%volts
tc = [34 48 65 82 93];

%Current source details
vdig = 5.04;	%volts
rone = 41.2e3;	%ohms
rtwo = 20e3;	%ohms

%Uncompensated resistance
rseries = 0;	%ohms

%ideality
eta = 2;		%dimensionless

%boltzmann's constant
kbolt = 1.38e-23;	%m^2 kg / s^2 K

%electron charge
charge = 1.6e-19;	%coulombs



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Begin calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
points = size(currents,2);
lowcurr = (vdig - vbe_one) / rone;
highcurr = (vdig - vbe_two) / rtwo;
vdiff = vbe_two - vbe_one;
idiff = highcurr - lowcurr;

for count = 1:points,
	temp(count) = charge * (vdiff(count) - rseries * idiff(count)) ...
		./ (eta * kbolt * log(highcurr(count) / lowcurr(count))); %Kelvin
end;

plot(currents,temp-273,'-',currents,tc,'-',currents,tc*1.7,'o');
xlabel('Output current (A)');
ylabel('Temp (C)');
	
	


