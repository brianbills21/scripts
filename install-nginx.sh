#Run this script as root

#Test if a daemon is listening on port 80, if not install nginx
if [[ ! -z $(netstat -an | grep "0.0.0.0:80") ]]; then echo "listening on 80"; else

#apt update
apt update

#Install nginx
apt install -y nginx

#Open port for nginx http
ufw allow 'Nginx HTTP'

#Enable nginx
systemctl enable nginx

#Create a folder for mj12net.org
mkdir /etc/nginx/sites-available/mj12net.org/html

#Assign ownership of the directory with the $USER environment variable
chown -R $USER:$USER /var/www/mj12net.org/html

#To ensure that your permissions are correct and allow the owner to read, write, 
#and execute the files while granting only read and execute permissions to groups 
#and others, you can input the following command
chmod -R 755 /var/www/mj12net.org

#Create a blank index.html page
touch /var/www/mj12net.org/html/index.html

#In order for Nginx to serve this content, it’s necessary to create a server block 
#with the correct directives. Instead of modifying the default configuration file 
#directly, let’s make a new one at
cat <<EOF > /etc/nginx/sites-available/mj12net.org
server {
        listen 80;
        listen [::]:80;

        root /var/www/mj12net.org/html;
        index index.html index.htm index.nginx-debian.html;

        server_name mj12net.org www.mj12net.org;

        location / {
                try_files $uri $uri/ =404;
        }
}
EOF

#Link mj12net.org to sites-enabled
ln -s /etc/nginx/sites-available/mj12net.org /etc/nginx/sites-enabled/

#Make /var/www/mj12net.org/html/index.html your home page
cat << EOF | sed '/^http {$/ r /dev/stdin' /etc/nginx/nginx.conf
server {
        server_name  $(hostname -I | cut -d' ' -f1);
        listen       80;
        root         /var/www/mj12net.org/html;
        index        index.html;
        }
EOF

#Zero out index.html
>/var/www/mj12net.org/html/index.html

#Add mj12net.org to your host file

 echo "$(hostname -I | cut -d' ' -f1) mj12net.org" >> /etc/hosts

#Restart nginx
systemctl restart nginx
fi
