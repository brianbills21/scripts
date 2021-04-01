#Script called from root's crontab to change letsencrypt certs every 90 days
#Called like this: 0 5 */90 * * /usr/share/jenkins/change_jenkins_certs.sh
systemctl stop jenkins
mv /usr/share/jenkins/fullchain1.pem /usr/share/jenkins/fullchain1.pem_$(date +%m-%d-%Y)
mv /usr/share/jenkins/privkey-rsa.pem /usr/share/jenkins/privkey-rsa.pem_$(date +%m-%d-%Y)
cp /etc/letsencrypt/live/jenkins.usreliance.com/* /usr/share/jenkins/
openssl rsa -in /usr/share/jenkins/privkey.pem -out /usr/share/jenkins/privkey-rsa.pem
mv /usr/share/jenkins/fullchain.pem fullchain1.pem
systemctl start jenkins
