#Script called from root's crontab to change letsencrypt certs every 90 days
systemctl jenkins stop
mv /usr/share/jenkins/fullchain1.pem /usr/share/jenkins/fullchain1.pem_$(date +%d-%m-%Y)
mv /usr/share/jenkins/privkey-rsa.pem /usr/share/jenkins/privkey-rsa.pem_$(date +%d-%m-%Y)
cp /etc/letsencrypt/live/jenkins.usreliance.com/* /usr/share/jenkins/
openssl rsa -in /usr/share/jenkins/privkey.pem -out /usr/share/jenkins/privkey-rsa.pem
mv /usr/share/jenkins/fullchain.pem fullchain1.pem
systemctl start jenkins
