#!/bin/bash
# Install Splunk 6.2 on CentOS 7 as a non-root user service that runs on boot with 
# systemd. This script also opens the firewall to allow syslog on UDP port 514. Since
# we're running Splunk as non-root, this port is then forwarded to 5514. Configuring a
# syslog input in slunk on UDP 514 will gather this data.  Must be run as root

# Create Account
useradd splunk
groupadd splunk

# Install RPM from CLI argument
yum -y install $1

# Set environment var permanently and then for this session
echo "export SPLUNK_HOME=/opt/splunk" > /etc/profile.d/splunk.sh
export SPLUNK_HOME=/opt/splunk

# Set ownership on SPLUNK_HOME
chown -R splunk:splunk $SPLUNK_HOME

# Firewall mods
# Allow web access on port tcp 8000, syslog on udp 5514
firewall-cmd --zone=public --permanent --add-port=8000/tcp
firewall-cmd --zone=public --permanent --add-port=5514/udp

# Forward syslog input to high port for non-root, allow port 80 for http
firewall-cmd --direct --permanent --add-rule ipv4 nat PREROUTING 0 -p udp -m udp \
  --dport 514 -j REDIRECT --to-ports 5514
firewall-cmd --direct --permanent --add-rule ipv4 nat PREROUTING 0 -p tcp -m tcp \
  --dport 80 -j REDIRECT --to-ports 8000

# Reload firewall
firewall-cmd --reload

# Create Systemd Unit file
echo "[Unit]
Description=Splunk Enterprise
Wants=network.target
After=network.target
[Service]
User=splunk
RemainAfterExit=yes
ExecStart=/opt/splunk/bin/splunk start
ExecStop=/opt/splunk/bin/splunk stop
ExecReload=/opt/splunk/bin/splunk restart
[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/splunk.service

# Link the Unit File as a service
ln -sf /usr/lib/systemd/system/splunk.service \
  /etc/systemd/system/multi-user.target.wants/splunk.service

# First Run
sudo -H -u splunk $SPLUNK_HOME/bin/splunk start --accept-license
echo "You should now restart your machine, Splunk will run on boot"
