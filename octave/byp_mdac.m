%byp_mdac.m
%Simulates the mDAC arrangement illustrated in byp_mdac.fig

clear;
close all;


%How many bits does the mDAC have?
bits = 12;
steps = 2^bits;

%Desired gain
desire_gain = 0.75;


%alpha will run from 0.01 to 1 -- it's not a good idea to run it much 
%below 0.01
alpha = linspace(0.01,1,steps);


%Define the external resistors
Ref = 1.02e3;			%The external feedback resistor
Rb = 1.33e3;			%The resistor bypassing the mDAC

%The feedback capacitor.  The AD5452 recommends 2 pF on top of the 1.3p 
%already in the package
%The minimum capacitance I can probably get away with is 4p
Cfb = 4e-12;		%Feedback capacitor in farads

%The internal feedback resistor will have some variability -- 9k to 11k.  
%Luckily, Rin and Rif will vary together -- this is how the DAC is able 
%to have gain accuracy
%Rif will vary between 9k and 11k for the ad5452
Rif = [9e3,10e3,11e3];

%Calculate the new bandwidth based on the parallel combination of Ref 
%and Rif
Rfb = Ref*Rif(2)/(Ref+Rif(2));
fc = 1/(2*pi*Cfb*Rfb);


	


%Calculate gain for all ranges of alpha and Rif
for count = 1:3,
	Rpara(count) = (Rif(count)*Ref)/(Rif(count)+Ref);
	gain{count} = (alpha/Rif(count) + 1/Rb)*Rpara(count);
end

%Find how many settings we have within a certain fraction of desired gain
desire_error = 0.1;	%Fraction of the desired gain we have to correct for
findvec = find(gain{2} > (1-desire_error)*desire_gain & gain{2} < (1+desire_error)*desire_gain);
good_settings = size(findvec,2);
if good_settings == 0,
	disp('No good DAC settings for target gain and error range');
	break;
end;
good_alphas = alpha(findvec);
good_gains = gain{2}(findvec);



%Calculate minimum set ability
%The minimum setpoint precision will be at the lowest alpha values.  
%Just look at the lowest one
min_frac = (gain{1}(2)-gain{1}(1))/gain{1}(1);
%for count = 1:steps-1,
%	frac_inc(count) = (gain{1}(count+1)-gain{1}(count))/gain{1}(count);
%end

%Calculate amplitude attenuation at 1MHz
spoint = j*2*pi*1e6;
sbw = j*2*pi*fc;
filter = 1/(spoint/sbw+1);
atten = abs(filter);
	


disp('************************************************************');
%Display bandwidth
printf("Bandwidth is %4.1f MHz \n\n",fc/1e6);

printf("Attenuation at 1MHz assuming 1st-order filter is %3.2f \n\n",atten);

%Display minimum setability
printf("Minimum setting precision is %2.0f ppm.\n",min_frac*1e6);
printf("We would like to see less than 100ppm. \n\n");


%Display number of settings
printf("%d settings within ",good_settings);
printf("%d percent of desired gain \n\n",100*desire_error);


%Plot the result
%plot(alpha,gain{1},'@',alpha,gain{2},'@',alpha,gain{3},'@');
plot(alpha,gain{1},';Rif = 9k;',alpha,gain{2},';Rif = 10k;',alpha,gain{3},';Rif = 11k;',good_alphas,good_gains,'@',[min(alpha) max(alpha)],[gain{2}(steps/2) gain{2}(steps/2)]);
xlabel('Fractional mDAC setting (alpha)');
ylabel('Gain');
legend('Location','Southeast')
replot
