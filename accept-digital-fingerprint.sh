#This is an unsafe script if used in an environment where somebody unauthorized can ngrep
#your packets, or from a console on the same machine can type ps -ef | grep first-login.sh
#This script accepts the digital fingerprint automagically so you don't have to.
#It's a nice feature used in a loop or from an ansible playbook when you have just built
#many new hosts and you don't want to do it manually on every single one.

user="root"
server=$1

first-login()
{
expect <<EOD
#!/usr/bin/expect 
set prompt "#|>|\\\$"
spawn ssh $user@$server
expect {
        #If 'expect' sees '(yes/no )', then it will send 'yes'
        #and continue the 'expect' loop
        "(yes/no)" { send "yes\r";exp_continue}
        #If 'password' seen first, then proceed as such.
        "password"
}
EOD
}
first-login $user $server

user="bbills"
server=$1

first-login()
{
expect <<EOD
#!/usr/bin/expect
set prompt "#|>|\\\$"
spawn ssh $user@$server
expect {
        #If 'expect' sees '(yes/no )', then it will send 'yes'
        #and continue the 'expect' loop
        "(yes/no)" { send "yes\r";exp_continue}
        #If 'password' seen first, then proceed as such.
        "password"
}
EOD
}
first-login $user $server
