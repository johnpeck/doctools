%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The big rail voltage -- stays constant and positive
Vcc = 37;	%Volts

%Maximum output current.  Change this to estimate variation in
%bootstrap rails with output current
Imax = 1;	%Amps

%Transistor beta.  Should be 1000 for Darlingtons
beta = 1e3;

%Choose R1.  R2 will be chosen based on slope
Rone = 900;	%Ohms

%The peak output voltage desired.  Used to calculate power dissipation
Vpk = 30;

%The padding resistors for parallel transistors.  For three 1 ohm
%resistors in parallel this should be 0.33
Rpad = 0.33;


%The slope of the rail voltage vs the output voltage.  This
%is alpha in my notes
slope = 0.87;	%Dimensionless

%Diode forward voltage -- this should always be 0.7
Vd = 0.7;	%Volts

%Transistor Vbe -- 0.7 for single transistor or 1.4 for Darlington.
Vbe = 1.4;	%Volts

%Number of diodes to use (integer)
dnum = 5;	%Diodes

%Voltage headroom for opamp -- how close can output get to rail
head = 2;	%Volts
