# turbplot.gp
#
# Plot histograms and estimated sample distributions for Dana
# turbulators tested at 4 standard liters per minute.

clear
reset
set terminal x11
set key top right

# Data from running turbin.m octave script
gpmean = 0.38520 
gpstd = 0.0038987
ntsmean = 0.49300
ntsstd = 0.0080932
nbtmean = 0.40660
nbtstd = 0.011866

# The normal distribution
regnorm(x,mean,std) = (1/(std*sqrt(2*pi)))*exp(-(x-mean)**2/(2*std**2))
set samples 500

set xrange [0.35:0.55]
set yrange [0:3.5]
set style fill empty border
set boxwidth 1 relative
set xlabel 'Back pressure (inches of water)'
set ylabel 'Number of parts'
set ytics 1, 1 # Draw tic marks at 1, 2, 3, ...

plot 'gp4lpm_binned.dat' using 1:2 with boxes\
     title 'Good parts' axes x1y1
replot mean = gpmean, std = gpstd, regnorm(x,mean,std)\
     title 'Estimated good part distribution' axes x1y2
replot 'nts4lpm_binned.dat' using 1:2 with boxes\
     title 'No turb sand (NTS) parts' axes x1y1
replot mean = ntsmean, std = ntsstd, regnorm(x,mean,std)\
     title 'Estimated NTS part distribution' axes x1y2
replot 'nbt4lpm_binned.dat' using 1:2 with boxes\
     title 'No bottom turb (NBT) parts' axes x1y1
replot mean = nbtmean, std = nbtstd, regnorm(x,mean,std)\
     title 'Estimated NBT part distribution' axes x1y2

# Add labels
set label "Good parts" at 0.403,2.25
set arrow from 0.4,2.25 to 0.389,2.25
set label "No bottom\nturb parts" at 0.433,1.82
set arrow from 0.431,1.65 to 0.412,1.05
set label "No turb\nsand parts" at 0.516,1.82
set arrow from 0.514,1.64 to 0.5,1.27

# Output to png
set output 'turbtest_histogram.png'
set terminal png
replot

# Finish by generating interactive plot again
set terminal x11
replot
