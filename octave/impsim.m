% impsim.m
% Generates a nyquist plot given a set of passives.
clear;
close all;
setenv ("GNUTERM", "x11"); 

% show the schematic
disp(system("imview impsim_schem.png",1,"async"));

%Pick resistors and capacitors in parallel blocks
rpara = [1e3, 4.7e3];   %Ohms
cpara = [1e-7, 3.3e-6]; %Farads

%The series resistor
rser = 1e3;

%The frequency sweep
freqlist = logspace(0,5,100);

ztot = 0;
ytot = 0;
yblock = 0;
zblock = zeros(size(freqlist,2),1);
% Calulate impedance
for freqcnt = 1:size(freqlist,2),
    for blockcnt = 1:size(rpara,2),
        yblock = 1/rpara(blockcnt) + j * 2 * pi * freqlist(freqcnt) * ...
            cpara(blockcnt);
        zblock(freqcnt) = zblock(freqcnt) + 1/yblock;
    end; % end stepping through parallel blocks
end; % end stepping through frequencies

ztot = zblock + rser;
ytot = 1./ztot; % The admittance

% Create the Nyquist plot
% Create the figure with the coordinates:
% [xorigin,yorigin,xwidth,ywidth]
% ...where I think the widths are in pixels
% figure(1,'Position',[0,0,700,500]) 
figure(1)
zscale = 1000; % Scale factor for impedance plotting
zunits = 'k\Omega'; % Units for impedance plotting
plot(real(ztot)/zscale,-imag(ztot)/zscale,"x", ...
    real(ztot(1))/zscale,-imag(ztot(1))/zscale,"x","markersize",20, ...
    real(ztot(end)/zscale),-imag(ztot(end)/zscale),"x","markersize",20);
title('Nyquist plot','fontsize',20);
xlabel(cstrcat('Z_{Re} ','(',zunits,')'),'fontsize',20);
ylabel(cstrcat('-Z_{Im} ','(',zunits,')'),'fontsize',20);
text(0.9*real(ztot(1)/zscale),-imag(ztot(1)/zscale), ...
    sprintf('%0.0f Hz',freqlist(1)),'fontsize',20)
text(1.1*real(ztot(end)/zscale),-imag(ztot(end)/zscale), ...
    sprintf('%0.0f kHz',freqlist(end)/1000),'fontsize',20)
axis([500/zscale 7000/zscale -100/zscale 2500/zscale]);
print -deps -color zfig.eps
disp('Nyquist plot printed to zfig.eps')


% Create the admittance plot
% figure(2,'Position',[100,100,700,500])
figure(2)
yscale = 1000; % Scale admittances up by this factor
yunits = 'mS';
plot(real(ytot)*yscale,imag(ytot)*yscale,'x', ...
    real(ytot(1))*yscale,imag(ytot(1))*yscale,"x","markersize",20, ...
    real(ytot(end))*yscale,imag(ytot(end))*yscale,"x","markersize",20);
title('Admittance plot','fontsize',20);
xlabel(cstrcat('Y_{Re} ','(',yunits,')'),'fontsize',20);
ylabel(cstrcat('Y_{Im} ','(',yunits,')'),'fontsize',20);
text(1.1*real(ytot(1))*yscale,imag(ytot(1))*yscale, ...
    sprintf('%0.0f Hz',freqlist(1)),'fontsize',20);
text(0.9*real(ytot(end))*yscale,imag(ytot(end))*yscale, ...
    sprintf('%0.0f kHz',freqlist(end)/1000),'fontsize',20)
axis([1e-4*yscale 1.1e-3*yscale -1e-5*yscale 3e-4*yscale]);
print -deps -color yfig.eps
disp('Admittance plot printed to yfig.eps')


