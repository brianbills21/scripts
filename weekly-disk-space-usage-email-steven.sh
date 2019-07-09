#!/bin/sh

HOSTNAME=`hostname`
EMAIL=udu-eng-svcs-infra@hp.com
#EMAIL=mark.steven.fong@hp.com
MYEMAIL=mark.steven.fong@hp.com
EMAIL2=michelle.vanderzyl@hp.com
JMREPORT_DIR=/share/it-ops/Build_Farm_Reports/Disk_Usage_Output_JM
OUTPUTDIR=/share/it-ops/Build_Farm_Reports/Email
OUTPUTFILE=$HOSTNAME-JM_Report_email

TITLE="DAILY Build Server Workspace Disk Usage report"

fTEXTEMAIL ()
{
    #mailx -s "$TITLE" -r "$MYEMAIL" -v "$EMAIL,$EMAIL2,$EMAIL3" <<EOF
mailx -s "$TITLE" -v "$EMAIL,$EMAIL2" <<EOF


From: udu-eng-svcs-infra@hp.com
To: $EMAIL,$EMAIL2
Subject:Build Server Workspace Disk Usage report

Hello Team,

A script was run on the Host ( ${HOSTNAME} ) to find out how much space is being utilized.

( ${HOSTNAME} ) Report:

`/share/it-ops/scripts/BUILD_FARM/disk-usage-JM.pl `


Thanks,
UDU-Eng-Services

EOF
}

fHTMLEMAIL ()
{
    echo "(" >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "From: udu-eng-services@HP.com "' >> $OUTPUTDIR/$OUTPUTFILE
    echo "echo 'To: ${EMAIL},${MYEMAIL},${EMAIL3}'" >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "MIME-Version: 1.0"' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "Content-Type: multipart/alternative; "' >> $OUTPUTDIR/$OUTPUTFILE
    echo "echo ' boundary="some.unique.value.ABC123/server.xyz.com"'" >> $OUTPUTDIR/$OUTPUTFILE
    echo "echo 'Subject: Workspace Disk Usage report for $HOSTNAME'" >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo ""' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "This is a MIME-encapsulated message"' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo ""' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "--some.unique.value.ABC123/server.xyz.com"' >> $OUTPUTDIR/$OUTPUTFILE
    #echo 'echo "Content-Type: text/html; charset='utf-8'"' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "Content-Type: text/html"' >> $OUTPUTDIR/$OUTPUTFILE
    #echo 'echo "Content-Transfer-Encoding: quoted-printable"' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo ""' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "<html>' >> $OUTPUTDIR/$OUTPUTFILE
    echo "<head>" >> $OUTPUTDIR/$OUTPUTFILE
    echo "<title>( ${HOSTNAME} ) Report:</title>" >> $OUTPUTDIR/$OUTPUTFILE
    echo "</head>" >> $OUTPUTDIR/$OUTPUTFILE
    echo "<body>" >> $OUTPUTDIR/$OUTPUTFILE
    echo "Hello Team ,<br>" >> $OUTPUTDIR/$OUTPUTFILE
    echo "<br>" >> $OUTPUTDIR/$OUTPUTFILE
    echo "Usage by user / host / workspace directory: <BR>" >> $OUTPUTDIR/$OUTPUTFILE
    
    for FILEENTRY in `cat "$JMREPORT_DIR/$HOSTNAME-workspace_disk_usage.JMdiskusageout" |egrep -v "net|Usage|by|user|//" | sed 's|MB|MB<BR>|g' | sed 's|:|:<BR>|g'`
    do
        echo "$FILEENTRY" >> $OUTPUTDIR/$OUTPUTFILE
    done
    echo "</body>" >> $OUTPUTDIR/$OUTPUTFILE
    echo '</html>"' >> $OUTPUTDIR/$OUTPUTFILE
    echo 'echo "--some.unique.value.ABC123/server.xyz.com"' >> $OUTPUTDIR/$OUTPUTFILE
    echo ") | /usr/lib/sendmail -t" >> $OUTPUTDIR/$OUTPUTFILE
}


fMAIN ()
{
    fTEXTEMAIL
}

fMAIN
