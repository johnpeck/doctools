%simvars.m
%This defines the variables used in electrochemical response simulation.

%The bulk concentration of redox-active species
cbulk = 0.1;	%mol / liter

%Number of transferred electrons
ntrans = 1;		%electrons

%The Faraday
faraday = 96485;	%coulombs / mol

%Electrode area
area = 1;		%mm^2

%Standard rate constant
kzero = 1;		%cm / s

%Diffusion coefficient for the oxidized species
dox = 1;		%cm^2 / s

%Diffusion coefficient for the reduced species
dred = 1;		%cm^2 / s

%Charge transfer coefficient
alpha = 1;		%dimensionless

%Formal potential
eform = 1;		%volts

%Uncompensated solution resistance
ru = 1;			%ohms

%Time step
ts = 1;			%seconds

%Experiment time
tstop = 1;		%seconds




