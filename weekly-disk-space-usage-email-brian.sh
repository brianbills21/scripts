#Email to send a weekly disk space usage report to the DevOps manager.
#!/bin/bash
OUTPUT_DIR=/share/it-ops/Build_Farm_Reports/WorkSpace_Reports
#cd $OUTPUT_DIR
#tar -czf weekly_workspace_reports_$(date +%Y-%m-%d).tar.gz *.csv

# some variables
# refactoring the script such that all these values are
# passed from the outside as arguments should be easy

from="3PAR.IT.Operations@hp.com"
to="udu-eng-svcs-infra@hp.com,michelle.vanderzyl@hp.com,udu-eng-svcs-apps@hp.com"
subject="Weekly Workspace Report For Build Servers `perl -e 'use POSIX qw(strftime); print strftime "%a %b %e %Y",localtime(time()+ 3600*24*0);'`"
boundary="ZZ_/afg6432dfgkl.94531q"
body="
Dear UDU-ENG-SERVICES Team,


`printf '%.0s-' {1..60}; echo`
The following files were updated today:
`printf '%.0s-' {1..60}; echo`

`ls -lt "$OUTPUT_DIR"/sideshow.csv | awk '{print $9}'`
`ls -lt "$OUTPUT_DIR"/simpsons.csv | awk '{print $9}'`
`ls -lt "$OUTPUT_DIR"/moes.csv | awk '{print $9}'`
`ls -lt "$OUTPUT_DIR"/flanders.csv | awk '{print $9}'`

`printf '%.0s-' {1..93}; echo`
The following file contains the latest version of all these reports:
`printf '%.0s-' {1..93}; echo`

`ls -lt $OUTPUT_DIR/weekly_workspace_report_* | head -1 | awk '{print $9}'`


Thanks,
UDU-ENG-SERVICES"
declare -a attachments
attachments=( `ls -lt weekly_workspace_report_* | head -1 | awk '{print $9}'` )

# Build headers
{
    
    printf '%s\n' "From: $from
To: $to
Subject: $subject
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=\"$boundary\"

--${boundary}
Content-Type: text/plain; charset=\"US-ASCII\"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

$body
    "
    
    # now loop over the attachments, guess the type
    # and produce the corresponding part, encoded base64
    for file in "${attachments[@]}"; do
        
        [ ! -f "$file" ] && echo "Warning: attachment $file not found, skipping" >&2 && continue
        
        #mimetype=$(get_mimetype "$file")
        printf '%s\n' "--${boundary}
Content-Type: $mimetype
Content-Transfer-Encoding: base64
Content-Disposition: ent; filename=\"$file\"
        "
        
        base64 "$file"
        echo
    done
    
    # print last boundary with closing --
    
    printf '%s\n' "--${boundary}--"
    
} | sendmail -t -oi   # one may also use -f here to set the envelope-from
mv ./weekly_workspace_report_*.csv $OUTPUT_DIR/temp
