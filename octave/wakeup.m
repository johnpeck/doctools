%wakeup.m
%This is just a test of making a function in octave.  Note that the function
%name must match the function file name
function wakeup (message)
	printf ("\a%s\n", message);
endfunction
