#################################################################################################################
# Installs Ubuntu 16.04 LTS initially, then upgrades it to 18.04.2 and it will upgrade it to newer versions     #
# depending on when you run the install. Make sure that you get the initrd.gz and the linux files               #
# from here:                                                                                                    #
#                                                                                                               #
# sudo wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot \ #
# /ubuntu-installer/amd64/initrd.gz                                                                             #
# sudo wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot \ #
# /ubuntu-installer/amd64/linux                                                                                 #
#                                                                                                               #
# or the install will hang.                                                                                     #
#################################################################################################################

#!/bin/bash

# STES UP THE ENVIRONMENT
/usr/bin/apt-get install -y curl && /usr/bin/apt-get install -y openssh-server && /usr/bin/apt-get install -y wget

# GRABS THE PUPPET CLIENT
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb

# INSTALLS THE PUPPET CLIENT
dpkg -i puppetlabs-release-pc1-xenial.deb

# RUNS AN UPDATE
apt-get update

# INSTALLS THE PUPPET AGENT ON THE NEW HOST
/usr/bin/apt-get install -y puppet-agent

# UPGRADES UBUNTU 16.04 LTS TO 18.04 LATEST BETA
/usr/bin/apt update && /usr/bin/apt -y upgrade && /usr/bin/apt install ubuntu-release-upgrader-core && /usr/bin/apt -y update && do-release-upgrade -d -f DistUpgradeViewNonInteractive

# INSTALLS AND CONFIGURES NTP
/usr/bin/apt install -y ntp ntpdate && /usr/bin/ntpdate -u 0.ubuntu.pool.ntp.org && /usr/bin/timedatectl set-timezone America/Los_Angeles

# COPIES KEYS FOR ROOT AND USER STORED ON YOUR PRESEED SERVER TO THE NEW HOST, MAKES ALLOWANCE FOR ROOT TO REMOTE LOGIN
/bin/mkdir -p /root/.ssh
/bin/mkdir -p /home/bbills/.ssh
/usr/bin/curl -o /root/.ssh/authorized_keys http://192.168.134.3/bbills/ssh-key/authorized_keys
/usr/bin/curl -o /home/bbills/.ssh/authorized_keys http://192.168.134.3/bbills/ssh-key/authorized_keys
/bin/chown -R bbills:bbills /home/bbills
/bin/sed -i 's/PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

# CONFIGURES NEW PUPPET AGENT
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

# INSTALLS VMWARE TOOLS ON NEW VMWARE VIRTUAL MACHINE
/usr/bin/apt-get install -y open-vm-tools
