#$1 hostname $2 last octet $3 MAC Address
set -x
zroot="/var/named"
subnet="192.168.134"
domain="mj12net.local."
dhcp="/etc/dhcp/dhcpd.conf"

systemctl stop dhcpd
echo "host "$1" {" >> $dhcp
echo "  hardware ethernet "$3";" >> $dhcp
echo "  option domain-name \"mj12net.local\";" >> $dhcp
echo "  option host-name \"$1\";" >> $dhcp
echo "  fixed-address "$subnet"."$2";" >> $dhcp 
echo "}" >> $dhcp
systemctl start dhcpd

cat $dhcp

systemctl stop named
echo $1"	IN	A	"$subnet"."$2 >> $zroot/mj12net.local.db
echo $2"     IN      PTR     "$1"."$domain"   	; "$subnet"."$2 >> $zroot/$subnet.db

ZONES_PATH="/var/named"
DATE=$(date +%Y%m%d)
# we're looking line containing this comment
NEEDLE="Serial"
for ZONE in $(ls -1 $ZONES_PATH) ; do
    curr=$(/bin/grep -e "${NEEDLE}$" $ZONES_PATH/${ZONE} | /bin/sed -n "s/^\s*\([0-9]*\)\s*;\s*${NEEDLE}\s*/\1/p")
    # replace if current date is shorter (possibly using different format)
    if [ ${#curr} -lt ${#DATE} ]; then
      serial="${DATE}00"
    else
      prefix=${curr::-2}
      if [ "$DATE" -eq "$prefix" ]; then # same day
        num=${curr: -2} # last two digits from serial number
        num=$((10#$num + 1)) # force decimal representation, increment
        serial="${DATE}$(printf '%02d' $num )" # format for 2 digits
      else
        serial="${DATE}00" # just update date
      fi
    fi
    /bin/sed -i -e "s/^\(\s*\)[0-9]\{0,\}\(\s*;\s*${NEEDLE}\)$/\1${serial}\2/" ${ZONES_PATH}/${ZONE}
    echo "${ZONE}: "
    grep "; ${NEEDLE}$" $ZONES_PATH/${ZONE}
done
systemctl start named

cat $zroot/mj12net.local.db && cat $zroot/$subnet.db

# What to backup. 
backup_files="/var/named /etc/named* /etc/dhcp/dhcpd.conf"

# Where to backup to.
dest="/root/backup"

if [ ! -d "$dest" ]; then
  # Control will enter here if $dest doesn't exist.
sudo mkdir -p /root/backup
fi

# Create archive filename.
day=$(date '+%d.%m.%Y_%H.%M.%S')
hostname=$(hostname -s)
archive_file="$hostname-$day.added.$1.tgz"

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