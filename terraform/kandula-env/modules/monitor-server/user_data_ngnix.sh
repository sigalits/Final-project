#! /bin/bash
set -e
echo "****Installing nginx"
apt update -y
apt install nginx -y
echo "<h1>Welcome to Grandpa's Whiskey at ${HOSTNAME}</h1>" |  tee /var/www/html/index.nginx-debian.html
systemctl start nginx
systemctl enable nginx
echo "****Mount /data"
sudo mkfs -t xfs /dev/xvds
mkdir /data
mount  /dev/xvds /data
echo "****add to fstab"
UUID=` blkid | grep xvds | awk  -F\" '{print $2}'\n`
echo "UUID=${UUID}  /data  xfs  defaults,nofail  0  2" |  tee -a /etc/fstab

echo "**** add to crontab cp to s3"

apt install -y  awscli
# Set region for CLI
mkdir -p ~/.aws

cat > ~/.aws/config << EOF
[default]
region = us-east-1
EOF

# shellcheck disable=SC1073
(crontab -l 2>/dev/null && echo "@hourly  aws s3 cp /var/log/nginx/access.log s3://whiesky-nginx-log/${HOSTNAME}_access.log") | crontab -
(crontab -l 2>/dev/null && echo "@hourly  aws s3 cp /var/log/nginx/access.log s3://whiesky-nginx-log/${HOSTNAME}_access.log") | crontab -