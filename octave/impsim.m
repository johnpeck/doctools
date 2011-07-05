%impsim.m
%Generates a nyquist plot given a set of passives.
clear;
close all;

%show the schematic
disp(system("imview impsim_schem.png",1,"async"));

%Pick resistors and capacitors in parallel blocks
rpara = [1e3, 4.7e3];	%Ohms
cpara = [1e-7, 3.3e-6];	%Farads

%The series resistor
rser = 1e3;

%The frequency sweep
freqlist = logspace(0,5,100);

ztot = 0;
ytot = 0;
yblock = 0;
zblock = zeros(size(freqlist,2),1);
%Calulate impedance

for freqcnt = 1:size(freqlist,2),
	for blockcnt = 1:size(rpara,2),
		yblock = 1/rpara(blockcnt) + j * 2 * pi * freqlist(freqcnt) * ...
			cpara(blockcnt);
		zblock(freqcnt) = zblock(freqcnt) + 1/yblock;
	end; %end stepping through parallel blocks
end; %end stepping through frequencies

ztot = zblock + rser;
plot(real(ztot),-imag(ztot), ...
	real(ztot(1)),-imag(ztot(1)),"x","markersize",20, ...
	real(ztot(end)),-imag(ztot(end)),"x","markersize",20);
xlabel("Real impedance component (ohms)");
ylabel("-(Imaginary impedance compontent) (ohms)");


