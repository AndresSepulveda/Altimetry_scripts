#!/bin/csh

#set CASENAME='"GreatLakes"'
#set LATMN=40.0
#set LATMX=50.0
#set LONMN=-95.0
#set LONMX=-75.0

set CASENAME='"SPChile2"'
set LATMN=-35.0
set LATMX=-30.0
set LONMN=-76.0
set LONMX=-70.0


#set CASENAME='"MICHILE"'
#set LATMN=-44.5
#set LATMX=-41.25
#set LONMN=-74.0
#set LONMX=-71.0

set YINI=2009
set YEND=2010 # ends in YEND-1
set YEAR=$YINI

#mkdir $CASENAME

while ($YEAR != $YEND)
sed 's/YEAR/'$YEAR'/'  < link_GLOBWAVE.sh.tmp  > link_GLOBWAVE.sh
chmod u+x link_GLOBWAVE.sh
sed 's/YEAR/'$YEAR'/g'  < link_WW3.sh.tmp  > link_WW3.sh
chmod u+x link_WW3.sh
sed -e 's/YEAR/'$YEAR'/' -e 's/CASENAME/'$CASENAME'/' -e 's/LONMN/'$LONMN'/' -e 's/LONMX/'$LONMX'/' -e 's/LATMN/'$LATMN'/' -e 's/LATMX/'$LATMX'/' < oct_alti_sortsat.m.tmp  > oct_alti_sortsat.m
chmod u+x oct_alti_sortsat.m
sed -e 's/YEAR/'$YEAR'/' -e 's/CASENAME/'$CASENAME'/' -e 's/LONMN/'$LONMN'/' -e 's/LONMX/'$LONMX'/' -e 's/LATMN/'$LATMN'/' -e 's/LATMX/'$LATMX'/' < oct_alti_ww3totrack.m.tmp  > oct_alti_ww3totrack.m
chmod u+x oct_alti_ww3totrack.m
sed -e 's/YEAR/'$YEAR'/' -e 's/CASENAME/'$CASENAME'/' -e 's/LONMN/'$LONMN'/' -e 's/LONMX/'$LONMX'/' -e 's/LATMN/'$LATMN'/' -e 's/LATMX/'$LATMX'/' < oct_plot_tracks.m.tmp  > oct_plot_tracks.m
chmod u+x oct_plot_tracks.m


./link_GLOBWAVE.sh

octave --silent oct_alti_sortsat.m

./link_WW3.sh

octave --silent oct_alti_ww3totrack.m

octave --silent oct_plot_tracks.m

 @ YEAR++
end	

#mv *$CASENAME* $CASENAME
