%bootstrap_calc.m
%Calculates bootstrap resistor values for a given quiescent current and rail values
%bootcalc does a better job of this

clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
quiet_current = 0.01;			%Amps -- the current in the bootstrap resistors when things are quiet		    
opamp_quiescent = 10e-3;		%Amps -- quiescent current drawn by the opamp

%bootstrap_hfe = 50;			%Bootstrap transistor hfe -- not used right now
big_rail_span = 74;			%Volts -- Vcc-Vee
bootstrap_rail_span = 20;		%Volts -- Vco-Veo
current_limit = 1.5;			%Amps -- output current limit
smallest_load = 1;			%Ohms -- the smallest load

%The compliance voltage -- the maximum absolute voltage the output
%can acheive
Vcomp = 30;	%Volts

%Vbe -- 0.6V for signal transistor, 1.2V for darlington.
Vbe = 1.2;	%Volts

%Vd -- 0.6V for one diode in resistor chain, 1.2V for two, so on
Vd = 1.2;	%Volts



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate rsum using big_rail_span and the quiet current
%rsum is the sum of the inner and outer resistors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rsum = (big_rail_span-2*Vbe)/(2*quiet_current);		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate inner resistor using bootstrap_rail_span
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r_inner = bootstrap_rail_span*rsum/(big_rail_span-2*Vbe);
r_outer = rsum-r_inner;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate power dissipation in bootstrap network resistors
%
%Power dissipation in the bootstrap network resistors
%will not be affected by the opamp's load, only the
%voltage output.
%
%The worst-case power dissipation in the bootstrap resistors
%will happen when the output is at one of its extremes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_bootstrap_current = (big_rail_span/2+pp_excursion/2)/rsum;
max_inner_diss = r_inner*max_bootstrap_current^2;
max_outer_diss = r_outer*max_bootstrap_current^2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate power dissipation in bootstrap transistors
%
%This power dissipation will just be Vce for the transistors
%multiplied by the collector current.  Let's assume a
%resistive load, so the maximum Vce happens when driving
%a short -- vout = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vout = linspace(-pp_excursion/2,pp_excursion/2,100);
%vout = linspace(0,pp_excursion/2,100);

vcc = big_rail_span/2;
vee = -vcc;
vco = ((vcc-Vbe)*r_inner+vout*r_outer)/(r_inner+r_outer);
vco_short = ((vcc-Vbe)*r_inner)/(r_inner+r_outer);
veo = ((vee+Vbe)*r_inner+vout*r_outer)/(r_inner+r_outer);
veo_short = ((vee+Vbe)*r_inner)/(r_inner+r_outer);
vce = vcc-vco;
short_vce = vcc-vco_short;
%Decide if we reach output current limit with load
max_i_load = opamp_quiescent+max(vout)/smallest_load;
if max_i_load > current_limit,
	max_i = current_limit;
else
	max_i = max_i_load;
end;
xistor_diss = short_vce*max_i;
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Report values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strone = 'Inner resistor is ';
strtwo = num2str(r_inner/1e3,'%0.1f');
strthree = 'kohm';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);
strone = 'Inner resistor maximum power dissipation is ';
strtwo = num2str(max_inner_diss*1e3,'%0.1f');
strthree = 'mW';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);

strone = 'Outer resistor is ';
strtwo = num2str(r_outer/1e3,'%0.1f');
strthree = 'kohm';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);
strone = 'Outer resistor maximum power dissipation is ';
strtwo = num2str(max_outer_diss*1e3,'%0.1f');
strthree = 'mW';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);
disp(' ');

strone = 'Maximum dissipation in bootstrap transistors is ';
strtwo = num2str(xistor_diss,'%0.2f');
strthree = 'W';
dispstr = [strone strtwo  ' ' strthree];
disp(dispstr);
disp(' ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Make plot showing rails vs output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(vout,vco,';Positive rail;',vout,veo,';Negative rail;',vout,vout,';Output;');
xlabel('Output voltage (V)');
ylabel('Volts (V)');



gset key bottom right;
replot;


