#Unsafe scrip if used in an environment where somebody unauthorized can sniff
#from a console on the same machine can type ps -ef | grep first-login.sh
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
