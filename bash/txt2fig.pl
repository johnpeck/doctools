#!/usr/bin/perl

# Andrew Daviel, TRIUMF
# Convert ASCII text to Fig

$y = 1400 ;
$x = 1000 ;
$dy = 400 ;  #  810 for 48pt  420 for 24pt 225 for 12pt 195 for 10pt
$pt = 12 ;
$fn = 12 ; # 12 for Courier 
# 0 times roman
# 1 times italic
# 2 times bold
# 3 times bold italic
# 4 avantgarde-book
$angle = '0.0000' ;
$depth = 50 ;
$colour = 0 ;
$just = 0 ; # left
$flags = 4 ;
$or = 'Portrait' ;

while ($o = shift(@ARGV)) {
 if ($o eq '-h' || $o eq '--help') { &dohelp ; exit ; }
 if ($o eq '-fn') { $fn = shift(@ARGV) ; }
 if ($o eq '-pt') { $pt = shift(@ARGV) ; }
 if ($o eq '-land') { $or = 'Landscape' ; }
 if ($o eq '-y') { $y = shift(@ARGV) ; }
 if ($o eq '-x') { $x = shift(@ARGV) ; }

}


$dy = 19 * $pt ;

print<<EOT;
#FIG 3.2
$or
Center
Inches
Letter
100.00
Single
-2
1200 2
EOT


while (<STDIN>){
  chomp ;
  $y+= $dy ;
  if ($_) {
 # type text = 4
 # justification 0 left 1 center 2 right
 # colour 0 black 4 red 1 blue
 # type  justif  colour depth  ?  font size  angle flags zz x  y  text
    print "4 $just $colour $depth 0 $fn $pt $angle  $flags  210 750 $x $y $_\\001\n" ;
  }
}

sub dohelp {
  print STDERR<<EOT;
Usage: $0 [-fn <font> (4)][-pt <point> (18)][-x <x> (1000)][-y <y> (1400)][-land]
Fonts:  
 0 times roman
 1 times italic
 2 times bold
 3 times bold italic
 4 avantgarde-book
EOT
}
