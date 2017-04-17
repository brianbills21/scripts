host=$1
user=bbills
password=2421Mission!
su-root()
{
expect <<EOD
#!/usr/bin/expect -f

set timeout 60
log_user 1
#set host $1
set password 2421Mission! 
set user bbills
set logfile output.txt
spawn ssh $user@$host
expect "(yes/no)? "
send "yes\n"
expect "*?assword:*"
send -- "$password\r"
#log_user 1
sleep 2
expect "$ "
send -- "sudo su -\r"
expect -gl {*?assword for bbills:*}
send -- "$password\r"
expect "# "
send -- "apt-get install -y curl && /usr/bin/curl -o /tmp/VMwareTools-10.1.5-5055693.tar.gz http://192.168.134.3/vmware/VMwareTools-10.1.5-5055693.tar.gz && cd /tmp && /bin/tar xzvf VMwareTools-10.1.5-5055693.tar.gz && /bin/chmod +x /tmp/vmware-tools-distrib/vmware-install.pl && /tmp/vmware-tools-distrib/vmware-install.real.pl -d\r"
log_file /home/bbills/output.log
expect "# "
log_file
send -- "exit\r";
send -- "exit\r";
exit 0
EOD
}
su-root
