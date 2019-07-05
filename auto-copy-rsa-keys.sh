########################################################################################
# Only use this if you're in am environment where someone can't ngrep your packets     #
# or do a `ps -ef | grep auto-copy-rsa-keys.sh`, it's really safer to do a ssh-copy-id #
# or copy the keys with puppet and then use ansible to manage the host. But if you     #
# happen to find yourself having to copy keys to 100+, already provisioned hosts in    #
# an environment with no puppet or ansible, use this script cautiously using           #
# ansible to do the operation en masse.                                                #
########################################################################################

#!/bin/bash

key="/home/brian.bills/.ssh/id_rsa.pub"
user="bbills"
password="******"
server=$1
parameter="StrictHostKeyChecking no"

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

mkdir-cat-key()
{
expect <<EOD
#!/usr/bin/expect -f
set timeout 30

#example of getting arguments passed from command line..
#not necessarily the best practice for passwords though...
set server [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]

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
send  "mkdir -p .ssh && cat id_rsa.pub >> ~/.ssh/authorized_keys\n"

expect {
    "> " {}
    "# " {}
    default {}
}

#login out
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
mkdir-cat-key $server $user $password
