###########################################################################################################
# Reads the output of a perl script that maintains statistics of disk space usage in a devops environment #
# The line stating with "awk", sorts the data and presents it in a "workspace report", combining it with  #
# other data obtained from top-5-disk-space-users.sh. If I ever use something like this again, I'll       #
# combine the scripts together and call them each as a funtion from the main routine.                     #
###########################################################################################################

#!/bin/bash
TODAY=`date +"%m-%d-%y"`
BUILDDIR=/share/es-ops/scripts/BUILD_FARM
OUTPUTDIR=/share/es-ops/Build_Farm_Reports/WorkSpace_Reports
#perl -x "$BUILDDIR"/disk-usage-JM.pl > "$OUTPUTDIR"/jm_output

# Redirect the output of the perl script to jm_output
./disk-usage-JM.pl > /share/es-ops/Build_Farm_Reports/WorkSpace_Reports/jm_output

# Add title to the spreadsheet
echo ",,,,,Weekly Workspace Report $TODAY" > "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Add two blank lines
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Add title "100GB+ Consumers on All Hosts/Workspaces"
echo ",,,,,100GB+ Consumers on All Hosts/Workspaces" >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Add two more blank lines
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Process the output data from disk-usage-JM.pl in the file jm_output, and print it here
awk '!/^ / {sub(":","",$1); name=$1; next} NF==3{a[name]+=$2} END {for (i in a) printf "%s,%5.2f,GB\n", i, a[i]/1024}' "$OUTPUTDIR"/jm_output | sort -t, -rnk2 | awk -F, '$2+0>100' >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Add two more blank lines
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Add title "Top 5 Consumers of Space on All Hosts/Workspaces"
echo ",,,,Top 5 Consumers of Space on All Hosts/Workspaces" >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv

# Add two more blank lines
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv

# Read the output of another script performed on several different hosts, and print it here
cat "$OUTPUTDIR"/sideshow_top_5_per_workspace_* "$OUTPUTDIR"/simpsons_top_5_per_workspace_* "$OUTPUTDIR"/moes_top_5_per_workspace_* "$OUTPUTDIR"/flanders_top_5_per_workspace_* >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv 

# Add title "Size and Used Values on all Hosts and Workspaces"
echo ",,,,Size and Used Values on all Hosts and Workspaces" >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv

# Add blank line
echo ",,,," >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv

# Read the value of several "script output" .csv files and print it here beneath the title above
cat "$OUTPUTDIR"/sideshow.csv "$OUTPUTDIR"/simpsons.csv "$OUTPUTDIR"/moes.csv "$OUTPUTDIR"/flanders.csv >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv

# Copy the final workspace report to the build directory
cp $OUTPUTDIR/weekly_workspace_report_"$TODAY".csv $BUILDDIR

# Delete the temporary data file jm_out
rm -Rf "$OUTPUTDIR"/jm_output

# Move all the files with *top_5_per^ in their names to a temp directory
mv "$OUTPUTDIR"/*top_5_per* "$OUTPUTDIR"/temp
