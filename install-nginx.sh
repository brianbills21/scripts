#Test if a daemon is listening on port 80, if not install nginx
if [[ ! -z $(netstat -an | grep "0.0.0.0:80") ]]; then echo "listening on 80"; else

#Install nginx
apt install -y nginx

#Open port for nginx http
ufw allow 'Nginx HTTP'

#Enable nginx
systemctl enable nginx

#Create a folder for mj12net.org
mkdir /etc/nginx/sites-available/mj12net.org/html

#Assign ownership of the directory with the $USER environment variable
chown -R $USER:$USER /var/www/your_domain/html

#To ensure that your permissions are correct and allow the owner to read, write, 
#and execute the files while granting only read and execute permissions to groups 
#and others, you can input the following command
chmod -R 755 /var/www/mj12net.org

#Create a blank indes.html page
touch /var/www/mj12net.org/html/index.html

#Link mj12net.org to sites-enabled
ln -s /etc/nginx/sites-available/mj12net.org /etc/nginx/sites-enabled/

#Make /var/www/mj12net.org/html/index.html your home page
cat << EOF | sed '/^http {$/ r /dev/stdin' /etc/nginx/nginx.conf
server {
        server_name  $(hostname -I | cut -d' ' -f1);
        listen       80;
        root         /var/www/mj12net.org/html;
        index        index.html;
EOF

#Zero out index.html
>/var/www/mj12net.org/html/index.html

#Add mj12net.org to your host file

 echo "$(hostname -I | cut -d' ' -f1) mj12net.org" >> /etc/hosts

#Restart nginx
systemctl restart nginx
fi
