#!/bin/bash
TODAY=`date +"%m-%d-%y"`
BUILDDIR=/share/es-ops/scripts/BUILD_FARM
OUTPUTDIR=/share/es-ops/Build_Farm_Reports/WorkSpace_Reports
#perl -x "$BUILDDIR"/disk-usage-JM.pl > "$OUTPUTDIR"/jm_output
./disk-usage-JM.pl > /share/es-ops/Build_Farm_Reports/WorkSpace_Reports/jm_output
echo ",,,,,Weekly Workspace Report $TODAY" > "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,,100GB+ Consumers on All Hosts/Workspaces" >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
awk '!/^ / {sub(":","",$1); name=$1; next} NF==3{a[name]+=$2} END {for (i in a) printf "%s,%5.2f,GB\n", i, a[i]/1024}' "$OUTPUTDIR"/jm_output | sort -t, -rnk2 | awk -F, '$2+0>100' >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
echo ",,,,Top 5 Consumers of Space on All Hosts/Workspaces" >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv
echo ",,,,," >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv
cat "$OUTPUTDIR"/sideshow_top_5_per_workspace_* "$OUTPUTDIR"/simpsons_top_5_per_workspace_* "$OUTPUTDIR"/moes_top_5_per_workspace_* "$OUTPUTDIR"/flanders_top_5_per_workspace_* >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv 
echo ",,,,Size and Used Values on all Hosts and Workspaces" >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv
echo ",,,," >> "$OUTPUTDIR"/weekly_workspace_report_"$TODAY".csv
cat "$OUTPUTDIR"/sideshow.csv "$OUTPUTDIR"/simpsons.csv "$OUTPUTDIR"/moes.csv "$OUTPUTDIR"/flanders.csv >> "$OUTPUTDIR"/weekly_workspace_report_$TODAY.csv
cp $OUTPUTDIR/weekly_workspace_report_"$TODAY".csv $BUILDDIR
rm -Rf "$OUTPUTDIR"/jm_output
mv "$OUTPUTDIR"/*top_5_per* "$OUTPUTDIR"/temp
