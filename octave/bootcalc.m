%bootcalc.m
%Calculates positive power supply rail voltages for a bootstrapped
%amplifier as a function of output voltage given the desired slope
%of the rail vs the output. Plots the rail voltage for integer
%numbers of diodes in series with the boostrap network
%
%Use the file bootcalc_params.m to input simulation parameters
clear;
close all;

bootcalc_params;	%Read the simulation parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Begin calculation -- no user entry below this line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
Vpoints = linspace(0,Vcc,100);
Rtwo = slope * Rone / (1 - slope);
Rpara = Rone * Rtwo / (Rone + Rtwo);

%Sag in the base drive voltage
Vsag = Imax/beta * Rpara;

%Drop over the padding resistors
Vpad = Imax * Rpad;

%Power dissipation in bootstrap resistors
ipk = (Vcc + Vpk)/(Rone + Rtwo);
pdiss_one = Rone * ipk^2;
pdiss_two = Rtwo * ipk^2;

%Power dissipation in each diode
pdiss_dio = ipk * Vd;

%Range of diode increments to plot
drange = 1;
dvals = (dnum-drange):1:(dnum+drange);



for count = 1:size(dvals,2),
	%Calculate the positive rail voltage
	Vout{count} = Vpoints;
	Vco{count} = Vcc*(1-slope) + dvals(count)*Vd*slope + ...
			Vout{count}*slope - Vbe - Vsag - Vpad;
	
	%Calculate the base drive voltage for 0 drive current
	Vb{count} = Vco{count} + Vbe;
	for incount = 1:size(Vpoints,2),
		%Check for limit conditions
		if Vb{count}(incount) >= Vcc,
			Vb{count}(incount) = Vcc;
			Vco{count}(incount) = Vb{count}(incount) - Vbe;
		end;
		if Vout{count}(incount) >= Vco{count}(incount) - head,
			Vout{count}(incount) = Vco{count}(incount) - head;
		end;
	end;
	%Calculate current in bootstrap resistors
	Ibst{count} = (Vcc - Vb{count})/Rtwo;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Report values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strone = 'Inner resistor is ';
strtwo = num2str(Rone/1e3,'%0.1f');
strthree = 'kohm';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);

strone = 'Inner resistor maximum power dissipation is ';
strtwo = num2str(pdiss_one*1e3,'%0.1f');
strthree = 'mW';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);


strone = 'Outer resistor is ';
strtwo = num2str(Rtwo/1e3,'%0.1f');
strthree = 'kohm';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);

strone = 'Outer resistor maximum power dissipation is ';
strtwo = num2str(pdiss_two*1e3,'%0.1f');
strthree = 'mW';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);
disp(' ');

strone = 'Power dissipation in each diode is ';
strtwo = num2str(pdiss_dio*1e3,'%0.1f');
strthree = 'mW';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);
disp(' ');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
for count = 1:size(dvals,2),
	if count == 1,
		strone = [num2str(count) ';Positive rail with '...
			 num2str(dvals(count)) ' diodes;'];
		strtwo = [num2str(count) ';Output voltage with '...
			num2str(dvals(count)) ' diodes;'];
		plot(Vpoints,Vco{count},strone,Vpoints,Vout{count},strtwo);
		hold on;
	else
		strone = [num2str(count) ';Positive rail with '...
			 num2str(dvals(count)) ' diodes;'];
		strtwo = [num2str(count) ';Output voltage with '...
			num2str(dvals(count)) ' diodes;'];
		string = [';' num2str(dvals(count)) ' diodes;'];
		plot(Vpoints,Vco{count},strone,Vpoints,Vout{count},strtwo);
	end;
end;
xlabel('Input voltage (V)');
ylabel('Voltage (V)');
string = [num2str(Imax) 'A output current'];
title(string);

%gset key bottom right;
legend('Location','Southeast');	%Added for octave 3
replot;
hold off;

%Uncomment this break to output second figure
break;

figure(2);
for count = 1:size(dvals,2),
	if count == 1,
		strone = [';Bootsrap resistor current with '...
			 num2str(dvals(count)) ' diodes;'];
		plot(Vpoints,Ibst{count},strone);
		hold on;
	else
		strone = [';Bootsrap resistor current with '...
			 num2str(dvals(count)) ' diodes;'];
		plot(Vpoints,Ibst{count},strone);
	end;
end;	
gset key top right;
replot;


