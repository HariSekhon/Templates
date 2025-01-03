#!/usr/bin/env gnuplot
#
#  Author: Hari Sekhon
#  Date: [% DATE  # 2025-01-02 06:47:34 +0700 (Thu, 02 Jan 2025) %]
#
#  [% VIM_TAGS %]
#
#  [% URL # https://github.com/HariSekhon/Templates %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

# ============================================================================ #
#                                 G N U p l o t
# ============================================================================ #

# Graph Title
set title "My Graph"

# Add watermark text to the graph (this text will appear as a watermark)
set label 1 "Hari Sekhon" at screen 0.5,0.5 center font ",10" textcolor rgb "gray" offset 5,0

# ============================================================================ #

# Labels for Axes
set xlabel "Blah"
set ylabel "% Whatever"

# Set Axis Ranges
set xrange [15:60]    # Covers the specified data range and slightly beyond
set yrange [0:100]    # Percentages range from 0% to 100%

# results in X axis labels every 2 years
#set xdata time

#set timefmt "%H"
#set format x "%H"

#set key off  # Turn off the legend key if it’s a single dataset

# ============================================================================ #
# X Labels

# Show X axis labels every 5 increments between 15 and 80
#set xtics 15, 5, 80

# Show these specific X axis labels
#set xtics ("15" 15, "20" 20, "25" 25, "30" 30)

# Trick to get X axis labels for every year
#stats "data/git_commit_times.dat" using 1 nooutput
#set xrange [STATS_min:STATS_max]
#set xtics 1

#set xtics rotate by -45  # fit more X labels without them overlapping by slanting them
# ============================================================================ #

# Style adjustments
set grid              # Show grid for better visualization
set grid linestyle 0  # default dotted grid lines to make it easier to see what values a point of a graph is
set key off           # Turn off the legend, as it’s a single dataset

#set boxwidth 0.8 relative  # width of bar chart bars

#set style fill solid
#set style line 1 linecolor rgb "black" lt 2 linewidth 1

# ============================================================================ #

# Border lines - add the numbers together
#
# 1 = Bottom
# 2 = Left
# 4 = Top
# 8 = Right
#
set border 3  # 3 means Bottom + Left

# ============================================================================ #

set datafile separator " "

# Output settings
#set terminal pngcairo size 800,600 enhanced font "Arial,12"  # PNG output
set terminal pngcairo size 1280,720 enhanced font "Arial,14"
set output "images/blah.png"  # Output file

# Plot data using a smooth line
#plot '-' using 1:2 with linespoints title "Blah" linecolor rgb "blue" pointtype 7 pointsize 1.5
#plot "data/file.dat" using 1:2 with boxes title 'Commits'

## Data points x y
#30  30
#35  20
#...
#e

## Define the data points
#$DATA <<EOD
#33  20.25
#35  15
#38  10
#EOD

#set table 'data.dat'
#plot 100 * exp(-0.1 * (x - 17)) with lines title "Tapering Curve" linecolor rgb "blue"
#unset table

# uncomment to see how the data points decline to try to smooth out the data above and then comment to switch back to filledcurves further down
#plot $DATA using 1:2 with points title "Blah" pointtype 2 pointsize 1 linecolor rgb "blue"

# Plot the shaded area and the line
#plot $DATA using 1:2 with filledcurves x1 title "test" linecolor rgb "blue" , \
#     'data.dat' using 1:2 with filledcurves x1 title "Tapering Curve" fillcolor rgb "blue" linewidth 2
     #'data.dat' using 1:2 with lines title "Tapering Curve" linecolor rgb "blue" linewidth 2
