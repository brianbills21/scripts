bbills@ns:~$ cat /var/www/html/run.sh
#!/bin/bash

/usr/bin/apt-get install -y curl && /usr/bin/apt-get install -y openssh-server && /usr/bin/apt-get install -y wget

curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb

dpkg -i puppetlabs-release-pc1-xenial.deb

apt-get update

/usr/bin/apt-get install -y puppet-agent

/usr/bin/apt-get update && /usr/bin/apt-get -y upgrade && /usr/bin/apt-get -y dist-upgrade

/usr/bin/apt-get install -y ntp ntpdate && /usr/bin/ntpdate -u 0.ubuntu.pool.ntp.org && /usr/bin/timedatectl set-timezone America/Los_Angeles

/bin/mkdir -p /root/.ssh
/bin/mkdir -p /home/bbills/.ssh
/usr/bin/curl -o /root/.ssh/authorized_keys http://192.168.134.3/bbills/ssh-key/authorized_keys
/usr/bin/curl -o /home/bbills/.ssh/authorized_keys http://192.168.134.3/bbills/ssh-key/authorized_keys
/bin/chown -R bbills:bbills /home/bbills
/bin/sed -i 's/PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

cat > /etc/puppetlabs/puppet/puppet.conf <<EOF
[main]
certname = puppet-agent.mj12net.local
server = puppet-master.mj12net.local
environment = production
runinterval = 1h
EOF

host_name=`hostname`

sed -i "s/certname = puppet-agent/certname = "$host_name"/g" /etc/puppetlabs/puppet/puppet.conf

/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

sudo /opt/puppetlabs/bin/puppet agent --test

/usr/bin/apt-get install -y open-vm-tools

#/usr/bin/curl -o /tmp/VMwareTools-10.0.10-4301679.tar.gz http://192.168.134.3/vmware/VMwareTools-10.0.10-4301679.tar.gz
#cd /tmp
#/bin/tar xzvf VMwareTools-10.0.10-4301679.tar.gz
#/bin/chmod +x /tmp/vmware-tools-distrib/vmware-install.real.pl
#/tmp/vmware-tools-distrib/vmware-install.real.pl
