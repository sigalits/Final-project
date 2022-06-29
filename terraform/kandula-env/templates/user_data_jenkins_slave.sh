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
echo "***** Installing trivy *****"
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
echo "***** Defining eks cluster *****"
aws eks update-kubeconfig --region ${region} --name ${eks_cluster}
aws configure --profile default set region ${region}
cp -rp ~root/.aws ~ubuntu/
chown -R ubuntu:ubuntu ~ubuntu/.aws
cp -rp ~root/.kube ~ubuntu/
chown -R ubuntu:ubuntu ~ubuntu/.kube

