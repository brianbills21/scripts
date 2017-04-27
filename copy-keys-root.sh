user="bbills"
password="*********"
server=$1
parameter="StrictHostKeyChecking no"
key="/home/brian.bills/expect_project/authorized_keys"

scp-key()
{
expect <<EOD
#!/usr/bin/expect -f
set key [lindex $argv 0]
set user [lindex $argv 1]
set server [lindex $argv 2]
set password [lindex $argv 3]
set timeout -1
spawn scp -o "$parameter" $key $user@$server:~/
expect {
        password: {send "$password\r" ; exp_continue}
        eof exit
}
EOD
}


mv-root-key()
{
expect <<EOD
#!/usr/bin/expect -f
set timeout 30

#example of getting arguments passed from command line..
#not necessarily the best practice for passwords though...
set server [lindex $argv 0]
set user [lindex $argv 1]
set pass [lindex $argv 2]

# connect to server via ssh, login, and su to root
send_user "connecting to $server\n"
spawn ssh $user@$server

#login handles cases:
#   login with keys (no user/pass)
#   user/pass
#   login with keys (first time verification)
expect {
  "> " { }
  "$ " { }
  "# " { }
  "assword: " {
        send "$password\n"
        expect {
          "> " { }
          "$ " { }
          "# " { }
        }
  }
  "(yes/no)? " {
        send "yes\n"
        expect {
          "> " { }
          "$ " { }
          "# " { }
        }
  }
  default {
        send_user "Login failed\n"
        exit
  }
}

#example command
#send "ls\n"
send  "sudo su -\r"
expect {
  "> " { }
  "$ " { }
  "# " { }
  {*password for bbills:*} {
        send "$password\n"
        expect {
          "> " { }
          "$ " { }
          "# " { }
        }
  }
}
send  "mkdir -p /home/bbills/.ssh && mkdir -p /root/.ssh && cp /home/bbills/authorized_keys \
/root/.ssh && cp /home/bbills/authorized_keys /home/bbills/.ssh && chown -R bbills:bbills \
/home/bbills/.ssh && /bin/sed -i 's/PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config \
&& chown -R root:root /root/.ssh && sudo systemctl restart sshd\r"

expect {
    "> " {}
    "# " {}
    default {}
}

#login out
send "exit\n"
send "exit\n"

expect {
    "> " {}
    "# " {}
    default {}
}

send_user "finished\n"
EOD
}

scp-key $key $user $server $password
mv-root-key $user $server $password
