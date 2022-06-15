#! /bin/bash
set -e
echo "Installing requierments"
sudo apt install nfs-common -y
sudo apt install awscli -y

echo "Efs mount"
echo " Printing variables passed"
echo "${efs_dns}"
echo " Creating Jenkins dir"
sudo mkdir /jenkins
sudo chown -R ubuntu:ubuntu /jenkins
sudo chown -R ubuntu:ubuntu /home/ubuntu
echo "mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /jenkins"
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /jenkins
echo "${efs_dns}:/  /jenkins  nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0" >> /etc/fstab
echo "Creating Symlink to mount"
container=$(docker ps | tail -1 | awk  '{print $1}')
echo "Container is $${container}"
docker stop $${container}
sudo mv  /home/ubuntu/jenkins_home /home/ubuntu/jenkins_home_old
sudo ln -s /jenkins/jenkins_home /home/ubuntu/jenkins_home
docker start $${container}
#echo "***** Installing kubectl *****"
#curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
#sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
##sudo apt install kubectl
#sudo apt-get update -y
#echo "***** Installing docker *****"
#sudo apt-get install docker.io -y
#echo "***** Installing openjdk-11-jre *****"
#sudo apt install openjdk-11-jre -y
#sudo systemctl start docker
#sudo systemctl enable docker
#sudo usermod -aG docker ubuntu
#echo "***** Defining eks cluster *****"
echo "***** aws configure *****"
aws configure --profile default set region ${region}
cp -rp ~root/.aws ~ubuntu/
chown -R ubuntu:ubuntu ~ubuntu/.aws







#echo " Linking jenkins dir"
#ln -sf /jenkins /var/lib/jenkins

