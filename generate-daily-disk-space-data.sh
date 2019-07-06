##############################################################################################
# This script runs daily and does a df -Pm on 4 different hosts. It redirects it's output to #
# files called $HOSTNAME.csv, i.e..., moes.csv. The script called xxxxxxxxxx.sh, combines    #
# the data from these files with output files from the script xxxxx.sh, and redirects all    #
# the data to a file called xxxxxxx.csv, which gets sent to the devops team manager in an    #
# email script called xxxxxx.sh                                                              #
##############################################################################################


#!/bin/bash
OUTPUT_DIR=/share/es-ops/Build_Farm_Reports/WorkSpace_Reports
BASE=/export/ws
TODAY=`date +"%m-%d-%y"`
HOSTNAME=`hostname`
case "$HOSTNAME" in
    sideshow) WORKSPACES3=( "bob_size" "bob_used" "mel_size" "mel_size" "sideshow-ws2_size" "sideshow-ws2_used" ) ;;
    simpsons) WORKSPACES3=(bart_size bart_used homer_size homer_used lisa_size lisa_used marge_size marge_used releases_size releases_used rt-private_size rt-private_used simpsons-ws0_size simpsons-ws0_used simpsons-ws1_size simpsons-ws1_used simpsons-ws2_size simpsons-ws2_used vsimpsons-ws_size vsimpsons-ws_used) ;;
    moes)     WORKSPACES3=(barney_size barney_used carl_size carl_used lenny_size lenny_used moes-ws2_size moes-ws2_used) ;;
    flanders) WORKSPACES3=(flanders-ws0_size flanders-ws0_used flanders-ws1_size flanders-ws1_used flanders-ws2_size flanders-ws2_used maude_size maude_used ned_size ned_used rod_size rod_used todd_size todd_used to-delete_size to-delete_used) ;;
esac
if ! [ -f "$OUTPUT_DIR/$HOSTNAME.csv" ]; then
echo "$HOSTNAME" >  "$OUTPUT_DIR/$HOSTNAME.csv" # with a linebreak
separator="," # defined empty for the first value
for v in "${WORKSPACES3[@]}"
do
  echo -n "$separator$v" >> "$OUTPUT_DIR/$HOSTNAME.csv" # append, concatenated, the separator and the value to the file
  #separator="," # comma for the next values
done
echo >> "$OUTPUT_DIR/$HOSTNAME.csv" # add a linebreak (if you want it)
case "$HOSTNAME" in
                sideshow) WORKSPACES4=( "bob" "mel" "sideshow-ws2" ) ;;
                simpsons) WORKSPACES4=(bart homer lisa marge releases rt-private simpsons-ws0 simpsons-ws1 simpsons-ws2 vsimpsons-ws) ;;
                moes)     WORKSPACES4=(barney carl lenny moes-ws2) ;;
                flanders) WORKSPACES4=(flanders-ws0 flanders-ws1 flanders-ws2 maude ned rod todd to-delete) ;;
esac
df -Pm "${WORKSPACES4[@]/#//export/ws/}" | awk '
BEGIN  { "date +'%m-%d-%y'" | getline date;
                         printf "%s",date }
        NR > 1 && NF { printf ",%s,%s", $2, $3; }
        END    { printf "\n"}' >> "$OUTPUT_DIR/$HOSTNAME.csv"
elif [ -f "$OUTPUT_DIR/$HOSTNAME.csv" ]; then
case "$HOSTNAME" in
                sideshow) WORKSPACES5=( "bob" "mel" "sideshow-ws2" ) ;;
                simpsons) WORKSPACES5=(bart homer lisa marge releases rt-private simpsons-ws0 simpsons-ws1 simpsons-ws2 vsimpsons-ws) ;;
                moes)     WORKSPACES5=(barney carl lenny moes-ws2) ;;
                flanders) WORKSPACES5=(flanders-ws0 flanders-ws1 flanders-ws2 maude ned rod todd to-delete) ;;
esac
df -Pm "${WORKSPACES5[@]/#//export/ws/}" | awk '
BEGIN  { "date +'%m-%d-%y'" | getline date;
                         printf "%s",date }
        NR > 1 && NF { printf ",%s,%s", $2, $3; }
        END    { printf "\n"}' >> "$OUTPUT_DIR/$HOSTNAME.csv"
else
:
fi
