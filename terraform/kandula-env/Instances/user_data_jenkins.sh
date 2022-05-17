#! /bin/bash
set -e
echo "***** Installing kubectl *****"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#sudo apt install kubectl
sudo apt-get update -y
echo "***** Installing docker *****"
sudo apt-get install docker.io -y
echo "***** Installing awscli ***** "
sudo apt-get remove awscli
sudo apt install awscli -y
echo "***** Installing openjdk-11-jre *****"
sudo apt install openjdk-11-jre -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
echo "***** Defining eks cluster *****"
aws eks update-kubeconfig --region ${region} --name ${eks_cluster}
aws configure --profile default set region ${region}
aws configure --profile default set aws_access_key_id `echo ${access_key}  | base64 --decode`
aws configure --profile default set aws_secret_access_key `echo ${secret_key}  | base64 --decode`
cp -rp ~root/.aws ~ubuntu/
chown -R ubuntu:ubuntu ~ubuntu/.aws
cp -rp ~root/.kube ~ubuntu/
chown -R ubuntu:ubuntu ~ubuntu/.kube



