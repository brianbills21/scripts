#!/bin/bash
OUTPUT_DIR=/share/es-ops/Build_Farm_Reports/WorkSpace_Reports
BASE=/export/ws
TODAY=`date +"%m-%d-%y"`
HOSTNAME=`hostname`
case "$HOSTNAME" in
        sideshow) WORKSPACES=(bob mel sideshow-ws2) ;;
        simpsons) WORKSPACES=(bart homer lisa marge releases rt-private simpsons-ws0 simpsons-ws1 simpsons-ws2 vsimpsons-ws) ;;
        moes)     WORKSPACES=(barney carl lenny moes-ws2) ;;
        flanders) WORKSPACES=(flanders-ws0 flanders-ws1 flanders-ws2 maude ned rod todd to-delete) ;;
esac
if ! [ -f $OUTPUT_DIR/$HOSTNAME_top_5_workspace_$TODAY.csv ]; then
echo "Top 5 consumers of space per workspace on server `hostname` $TODAY" > $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
echo ",,," >> $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
echo ",,," >> $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
for v in "${WORKSPACES[@]}"
do
echo "Top 5 consumers on workspace $v" >> $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
echo ",,," >> $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
find $BASE/$v -printf "%u  %s\n" | awk '{user[$1]+=$2}; END{ for(i in user)if(i !~ "root" && i !~ /^[0-9]+$/ && i !~ /^ [0-9]+$/)printf("%s,%.2f,GB\n",i,user[i]/2**30)}' | sort -t, -k+2 -n -r | head -5 >> $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
echo ",,," >> $OUTPUT_DIR/"$HOSTNAME"_top_5_per_workspace_$TODAY.csv
done
fi
