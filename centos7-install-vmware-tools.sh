mkdir -p /mnt/vmw-tools
mount /dev/cdrom /mnt/vmw-tools
VMW_TOOLS=$(ls /mnt/vmw-tools/ | grep .gz) 
cp -f /mnt/vmw-tools/${VMW_TOOLS} /tmp/
umount /mnt/vmw-tools
rmdir /mnt/vmw-tools
tar -zxvf /tmp/${VMW_TOOLS} -C /tmp/
cd /tmp/vmware-tools-distrib/
./vmware-install.pl -d default
rm -rf vmware-tools-distrib/
rm -f /tmp/${VMW_TOOLS}
cd ~
