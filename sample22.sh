#!/usr/bin/env bash
samps=""
chans=""
tParamPassed=false
rParamPassed=false
outfile=""
while getopts ':c:s:tro' opt; do
    case $opt in
        s) samps="$OPTARG" ;;
        c) chans="$OPTARG" ;;
        t) tParamPassed=true ;;
        r) rParamPassed=true ;;
        o) oParamPassed=true ;;
        *) printf 'Unrecognized option "%s"\n' "$opt" >&2
    esac
done
shift $(( OPTIND - 1 ))
[[ $oParamPassed = "true" ]] && { exec > outfile-$(date +%m-%d-%Y.%H:%M:%S); }
# if input_file is not specified, print usage and exit
if (( $# == 0 )); then
  echo "usage: $0 ([-s samples] [-c channels] | -t) file"
  exit 1
fi
infile=$1
rLines=$(hexdump -v -e '8/1 "%02x " "\n"' "$infile" | wc -l)
read -r size _ < <(wc -c "$infile")
lines=$(( (size - 1) / 8 ))             # last line number
#if (( rParamPassed == true )); then
#  printf "Total Samples in "$(basename $infile)":\t"$((lines+1))"\n"
#  exit 0
#fi
if [[ $rParamPassed == "true" ]]; then
  printf "Total Samples in "$(basename $infile)": "$rLines"\n"
else
hexdump -v -e '8/1 "%02x " "\n"' "$infile" |
awk -v samps="$samps" -v chans="$chans" -v lines="$lines" -v baseFileName="$(basename $infile)" -v tParamPassed="$tParamPassed" -v rParamPassed="$rParamPassed" -v oParamPassed="$oParamPassed" '
# expand comma-separated range parameters into individual numbers
# assigning indexes of array "a"
# omitted range parameters default to min or max individually
function expn(str, a, min, max,     i, j, b, c, l, last) {
  if (str == "") {                            # if "str" is empty
    for (i = min; i <= max; i++) a[i]         # then set full range
    last = max
  } else {
    gsub(/[^0-9,-]/, "", str)                 # remove irregular characters
    split(str, b, /,/)                        # split on ","
      for (i in b) {                          # loop over csv
        l = split(b[i], c, /-/)               # split on "-"
        if (l == 1) {                         # single number
          c[2] = c[1]                         # copy to c[2] to update "last"
          a[c[1]]
        } else if (l == 2) {                  # dash-ranged numbers
          if (c[1] == "") c[1] = min          # default to "min"
          if (c[2] == "") c[2] = max          # default to "max"
            for (j = c[1]; j <= c[2]; j++) a[j]
        }
        if (last < c[2]) last = c[2]          # update the "last" line number
      }
    }
    return last                               # last line number to process
  }
  BEGIN {
    # pass in total records and reset the totalIterated var
    totalRecords = lines
    # expand sample string to array "srange"
    last = expn(samps, srange, 0, lines)
    # expand channel string to array "crange"
    expn(chans, crange, 0, 3)
    # print channel header row
    printf "\t"
    for (c = 0; c <= 3; c++) {
      if (c in crange) {
        printf("\tCh%d", c)
      }
    }
    print ""
  }
  {
    if (NR-1 > last) {
      tPrint="1"
      if (tParamPassed && $tPrint == 1) {
        printf("Total Samples in %s:\t%d\nTotal Samples Processed:\t%d\n", baseFileName, lines+1, last+1)
      }
      exit 0             # exit earlier if remaining are out of interest
    }
    if (NR-1 in srange) {
      # print sample range
      printf("Sample %d:", NR-1)
      # print channel range in sample line
      for (c = 0; c <= 3; c++) {
        if (c in crange) {
          i = c * 2 + 1
          j = i + 1
          printf("\t0x%s%s", $i, $j)
        }
      }
      print ""
    }
  }
  END {
    tPrint="2"
    if (tParamPassed && tPrint == 2) {
      printf("Total Samples in %s:\t%d\nTotal Samples Processed:\t%d\n", baseFileName, lines+1, last+1)
    }
    oPrint="3"
    if (oParamPassed && oPrint == 3) {
     printf outfile
    }
}
'
fi
