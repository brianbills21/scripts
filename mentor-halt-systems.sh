ssh root@node922
password npwfsj
atq
7       2015-03-13 18:50 a root
cd /var/spool/at
ls
a00007016ab9ee  spool
cat a00007016ab9ee

#!/bin/sh
# atrun uid=0 gid=0
# mail root 0
umask 22
CVS_RSH=ssh; export CVS_RSH
FSP_DELAY=3000; export FSP_DELAY
FSP_DIR=/; export FSP_DIR
FSP_HOST=sjsysadm.sje.mentorg.com; export FSP_HOST
FSP_PORT=4444; export FSP_PORT
G_BROKEN_FILENAMES=1; export G_BROKEN_FILENAMES
HOME=/root; export HOME
KDEDIRS=/usr; export KDEDIRS
KDE_IS_PRELINKED=1; export KDE_IS_PRELINKED
LANG=en_US.UTF-8; export LANG
LESSOPEN=\|/usr/bin/lesspipe.sh\ %s; export LESSOPEN
LOADEDMODULES=; export LOADEDMODULES
MODULEPATH=/usr/share/Modules/modulefiles:/etc/modulefiles; export MODULEPATH
MODULESHOME=/usr/share/Modules; export MODULESHOME
NXDIR=/usr/NX; export NXDIR
PATH=/usr/lib64/qt-3.3/bin:/usr/NX/bin:/usr/bin:/bin; export PATH
PWD=/; export PWD
QTDIR=/usr/lib64/qt-3.3; export QTDIR
QTINC=/usr/lib64/qt-3.3/include; export QTINC
QTLIB=/usr/lib64/qt-3.3/lib; export QTLIB
REMOTEHOST=sjsysadm.sje.mentorg.com; export REMOTEHOST
REMOTEUSER=root; export REMOTEUSER
SHELL=/bin/bash; export SHELL
SHLVL=4; export SHLVL
SSH_ASKPASS=/usr/libexec/openssh/gnome-ssh-askpass; export SSH_ASKPASS
USER=root; export USER
_AST_FEATURES=UNIVERSE\ -\ ucb; export _AST_FEATURES
module=\(\)\ {\ \ eval\ \`/usr/bin/modulecmd\ bash\ \$\*\`"
"}; export module
A__z=\"\*SHLVL; export A__z
cd / || {
         echo 'Execution directory inaccessible' >&2
         exit 1
}
${SHELL:-/bin/sh} << 'marcinDELIMITER31a57d67'
#!/bin/ksh
PATH /usr/bin:/bin:/sbin:/usr/sbin
export PATH
#
ref_date="031415"
#
cur_date=`date '+%m%d%y'`
#
if [ "$cur_date" -gt "$ref_date" ]
then 
  echo  exit
  exit
fi
#
echo "The system node922 will be halted to clear all nfs stale mountpoints on Friday, Mar. 13, 2015 at 7:00 PM PST . All the systems in Fremont will unstable until Saturday Mar. 14, 2015 for QPM outages - Rajan Lakshmanan Fremont IT." > /usr/tmp/.x27209
/usr/bin/wall /usr/tmp/.x27209
/bin/rm /usr/tmp/.x27209
sleep 600
sync
sync
/sbin/halt

marcinDELIMITER31a57d67
