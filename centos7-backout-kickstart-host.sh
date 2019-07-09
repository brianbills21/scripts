################################################################################################
# This script reverses changes made to the CentOS kickstart environment for a new CentOS host  #
# build. It backs out the entry in dhcpd.conf of the dynamically static ip assignment for      #
# the host being backed out. It removes the A record and the PTR, (pointer), record of the     #
# host being backed out, and increments the serial numbers. It validates the accuracy and      #
# neatness of the configuration changes. It backs up the new configuration changes. It ensures #
# that both dhcpd and named are running after the change.                                      #
################################################################################################

#!/bin/bash
dhcp="/etc/dhcp/dhcpd.conf"
mj12net="/var/named/mj12net.local.db"
systemctl stop dhcpd
systemctl stop named
sed -i '/'"$1"'/,+6d' $dhcp
sed -i '/'"$1"'/d' $mj12net
sed -i '/'"$1"'/d' /var/named/192.168.134.db
systemctl start dhcpd
ZONES_PATH="/var/named"
DATE=$(date +%Y%m%d)
# we're looking line containing this comment
NEEDLE="Serial"
for ZONE in $(ls -1 $ZONES_PATH); do
  curr=$(/bin/grep -e "${NEEDLE}$" $ZONES_PATH/${ZONE} | /bin/sed -n "s/^\s*\([0-9]*\)\s*;\s*${NEEDLE}\s*/\1/p")
  # replace if current date is shorter (possibly using different format)
  if [ ${#curr} -lt ${#DATE} ]; then
    serial="${DATE}00"
  else
    prefix=${curr::-2}
    if [ "$DATE" -eq "$prefix" ]; then # same day
      num=${curr: -2}                       # last two digits from serial number
      num=$((10#$num + 1))                  # force decimal representation, increment
      serial="${DATE}$(printf '%02d' $num)" # format for 2 digits
    else
      serial="${DATE}00" # just update date
    fi
  fi
  /bin/sed -i -e "s/^\(\s*\)[0-9]\{0,\}\(\s*;\s*${NEEDLE}\)$/\1${serial}\2/" ${ZONES_PATH}/${ZONE}
  echo "${ZONE}: "
  grep "; ${NEEDLE}$" $ZONES_PATH/${ZONE}
done
systemctl start named
# What to backup.
backup_files="/var/named /etc/named* /etc/dhcp/dhcpd.conf"" "$dhcp

# Where to backup to.
dest="/root/backup"

if [ ! -d "$dest" ]; then
  # Control will enter here if $dest doesn't exist.
  sudo mkdir -p /root/backup
fi

# Create archive filename.
day=$(date '+%d.%m.%Y_%H.%M.%S')
hostname=$(hostname -s)
archive_file="$hostname-$day.deleted.$1.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
sudo tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest

ps -ef | grep dhcpd && ps -ef | grep named
