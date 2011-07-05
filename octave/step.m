%step.m
%Predicts and plots step response for an underdamped second-order
%system. Plots a range of damping factors.
clear;
close all;


%The damping factor (0 -> 1)
dampmin = 0.4;
dampmax = 0.5;

damping = linspace(dampmin,dampmax,3);

%The natural frequency (Hz)
fn = 1e6;

%----------------------------------------------------------------
%End of user input


%The time vector
timevec = linspace(0,5e-6,1000);

%Angular natual frequency
wn = 2*pi*fn;

%Frequency shift due to damping (wd/wn)
for count = 1:size(damping,2),
	wratio(count) = sqrt(1 - damping(count)^2);
	wd(count) = wn*wratio(count);
end;

%Calculate step responses for all damping factors
for count = 1:size(damping,2),
	stepres{count} = 1 - (exp(-damping(count)*wn*timevec)/wratio(count)).*sin(wd(count)*timevec + atan(wratio(count)/damping(count)));
end;

%Generate keys
for count = 1:size(damping,2)
	key{count} = [";Damping factor of " num2str(damping(count)) ";"];
end;


for count = 1:size(damping,2);
	if count == 1,
		plot(timevec,stepres{1},key{1});
		hold on;
	else
		plot(timevec,stepres{count},key{count});
	end;
end;
gset format x "%0.1s %c"
replot;
