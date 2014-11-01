# turbin.m
#
# Put turbulator data into bins.  Binned data will go into files:
# gp4lpm_binned.dat
# nts4lpm_binned.dat
# nbt4lmp_binned.dat
clear all;
close all;

# Import 4lpm data
gprawdata = dlmread('gp4lpm.dat'); # Good parts
ntsrawdata = dlmread('nts4lpm.dat'); # No turb sand parts
nbtrawdata = dlmread('nbt4lpm.dat'); # No bottom turb parts

# Trim out comment lines to make data vectors
gpdata = gprawdata(4:end,2);
ntsdata = ntsrawdata(4:end,2);
nbtdata = nbtrawdata(4:end,2);

presmax = 0.6; # Inches of water -- maximum pressure to plot
presmin = 0.3;
numbins = 100;
binwidth = (presmax - presmin)/(numbins);
presbins = [presmin : binwidth : presmax]';
gpbinnum = histc(gpdata,presbins);
ntsbinnum = histc(ntsdata,presbins);
nbtbinnum = histc(nbtdata,presbins);

dlmwrite('gp4lpm_binned.dat',[presbins,gpbinnum],' ');
dlmwrite('nts4lpm_binned.dat',[presbins,ntsbinnum],' ');
dlmwrite('nbt4lpm_binned.dat',[presbins,nbtbinnum],' ');

disp ("The good part mean pressure is"), disp(mean(gpdata));
disp ("The good part standard deviation is"), disp(std(gpdata));
disp ("The nts part mean pressure is"), disp(mean(ntsdata));
disp ("The nts part standard deviation is"), disp(std(ntsdata));
disp ("The nbt part mean pressure is"), disp(mean(nbtdata));
disp ("The nbt part standard deviation is"), disp(std(nbtdata));

