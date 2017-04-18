yum update -y && yum install -y perl
curl -o /tmp/VMwareTools-10.1.6-5214329.tar.gz http://192.168.134.4/pxe_files/VMwareTools-10.1.6-5214329.tar.gz
tar xzvf /tmp/VMwareTools-10.1.6-5214329.tar.gz
vmware-tools-distrib/vmware-install.pl -d
rm -Rf vmware-tools-distrib && rm -Rf /tmp/VMwareTools-10.1.6-5214329.tar.gz
