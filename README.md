```
# scripts
 README.md  
 accept-digital-fingerprint.sh  
 auto-copy-root-rsa-keys.sh     
 auto-copy-rsa-keys.sh  
 centos7-backout-kickstart-host.sh  
 centos7-install-splun62.sh   
 centos7-install-vmware-tools.sh  
 centos7-provision-new-kickstart-host.sh
 create-docker-jenkins.sh
 draw-box-around-content.sh  
 find-top-5-disk-space-users.sh   
 generate-daily-disk-space-data.sh   
 generate-subnet-hgost-type-report.sh   
 generate-subnet-host-report.sh   
 generate-weekly-disk-space-usage-report.sh
 install-nginx.sh
 log2html.sh
 mentor-halt-systems.sh   
 monitor-webwasher-proxy-logs.sh   
 separate-non-cylance-hosts.sh   
 ubuntu-delete-idle-sessions.sh   
 ubuntu-preseed-post-install-script.sh   
 ubuntu1604-vmwareupdate.sh  
 ubuntu1604-vmwareupdate.sh   
 ubuntu1604_backout-preseed-host.sh    
 ubuntu1604_provision-new-preseed-host.sh   
 weekly-disk-space-usage-email-brian.sh   
 weekly-disk-space-usage-email-steven.sh         
```
```
sample4.sh usage:
#################

The sample.bin file must be in the same folder as sample4.sh

You can run this file in place to return all possible samples:
[root@usreliance Biorad]#./sample4.sh

To return a sepecific sample 15:
[root@usreliance Biorad]#./sample4.sh | grep "Sample 15:"

To return the first 15 samples: NOTE: we're adding 1 to 15 for the column header
[root@usreliance Biorad]# ./sample4.sh | head -n 16

To return Sample 15 channel 3:
[root@usreliance Biorad]# ./sample4.sh | grep "Sample 15:" | awk '{print $1,$5}'

To return Sample 15 channel 2:
[root@usreliance Biorad]# ./sample4.sh | grep "Sample 15:" | awk '{print $1,$4}'

To return Sample 15 channel 1:
[root@usreliance Biorad]# ./sample4.sh | grep "Sample 15:" | awk '{print $1,$3}'

To return Sample 15 channel 0:
[root@usreliance Biorad]# ./sample4.sh | grep "Sample 15:" | awk '{print $1,$2}'
```
