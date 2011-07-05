%Vbe_temp.m
%Plots calculated diode temperatures given a list of Vbe values.  Allows
%for nonideality and series resistance influences
clear;
close all;


%Data into a 1ohm load with 8.7V supply rails.  Vdig is 5.04V
currents = [1e-3 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1];	%amps
vbe_one = 1e-3*[760 750 739 728 715 704 692 678 665 655 642 626];	%volts
vbe_two = 1e-3*[799 790 779 769 757 747 736 725 713 704 692 679];	%volts

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

plot(currents,temp-273,'x');
xlabel('Output current (A)');
ylabel('Temp (C)');
	
	


