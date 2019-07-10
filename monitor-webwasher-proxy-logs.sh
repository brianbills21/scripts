# This script monitors webwasher proxy logs from two hosts:

# modpxy007
# modpxy008

# to determine which hosts have yet to be migrated from McAfee to Cylance.

#!/bin/bash
TODAY=`date +"%y%m%d"`
set -x
if [ ! -h logs ]; then
    ln -s /opt/webwasher-csm/logs/ logs
fi
grep -E "(login|data-vs2|update|api|api2|my-vs2|download)\.cylance\.com" logs/access$TODAY* | grep -Eo "(10|172)(\.[0-9]{1,3}){3}" | sort -u >> dailyclientip
echo `date +%y%m%d-%H:%M:%S` >> dailyclients.`hostname`.$TODAY.csv
for i in `cat dailyclientip`
do
    echo $i",""$(nslookup $i | sed -n -e 's/^.*= //p' | sed 's/.$//')" >> dailyclients.`hostname`.$TODAY.csv
    sed -i -e '/^,/d' dailyclients.`hostname`.$TODAY.csv
done
scp dailyclients.`hostname`.$TODAY.csv root@modpxy008:~/
rm dailyclientip


#!/bin/bash
TODAY=`date +"%y%m%d"`
set -x
if [ ! -h logs ]; then
    ln -s /opt/webwasher-csm/logs/ logs
fi
grep -E "(login|data-vs2|update|api|api2|my-vs2|download)\.cylance\.com" logs/access$TODAY* | grep -Eo "(10|172)(\.[0-9]{1,3}){3}" | sort -u >> dailyclientip
echo `date +%y%m%d-%H:%M:%S` >> dailyclients.`hostname`.$TODAY.csv
for i in `cat dailyclientip`
do
    echo $i",""$(nslookup $i | sed -n -e 's/^.*= //p' | sed 's/.$//')" >> dailyclients.`hostname`.$TODAY.csv
    sed -i -e '/^,/d' dailyclients.`hostname`.$TODAY.csv
done
scp dailyclients.`hostname`.$TODAY.csv root@modpxy007:~/
rm dailyclientip
