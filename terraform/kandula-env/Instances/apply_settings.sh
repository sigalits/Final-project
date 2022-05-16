#! /bin/bash
echo "get bastion"
BASTION_IP=$(terraform output bastion_ip)
echo "get ips"
bastion=$(echo ${BASTION_IP} | sed 's/"//g')
echo "get cluster name"
cluster_name=$(terraform output Jenkins_alb_dns)
cluster_name=$(echo ${Jenkins_alb_dns} | sed 's/"//g')
echo ${cluster_name}
echo "get LB url for Jenkins"
alb_jenkins=$(terraform output Jenkins_alb_dns)
alb_jenkins=$(echo ${alb_jenkins} | sed 's/"//g')
echo ${alb_jenkins}

echo "create config"
mv ~/.ssh/config ~/.ssh/config.old
cat <<EOT > ~/.ssh/config
Host bastion
    StrictHostKeyChecking no
    HostName ${bastion}
    User ubuntu
    ForwardAgent yes
    UserKnownHostsFile /dev/null
    IdentityFile /home/pixellot/mid-project/terraform/bastion_key.pem
Host jenkins_server
    HostName 10.0.21.21
    User ubuntu
    IdentityFile /Users/user/jenkins.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    ForwardAgent yes
    UserKnownHostsFile=/dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256

Host jenkins_agent1
    HostName 10.0.21.10
    User ubuntu
    IdentityFile /Users/user/jenkins.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    ForwardAgent yes
    UserKnownHostsFile=/dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256

Host jenkins_agent2
    HostName 10.0.22.10
    User ubuntu
    IdentityFile /Users/user/jenkins.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    ForwardAgent yes
    UserKnownHostsFile=/dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256

Host bastion
    HostName ${bastion}
    User ubuntu
    IdentityFile /Users/user/PycharmProjects/Mid-project/terraform/initial_config/kandula.pem
    ForwardAgent yes
    SendEnv yes
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking accept-new

Host 10.0.*.*
    User ubuntu
    IdentityFile /Users/user/PycharmProjects/Mid-project/terraform/initial_config/kandula.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    ForwardAgent yes
    UserKnownHostsFile /dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256
EOT

echo "Please run job ${alb_jenkins}:8080/job/kandula-build-pipeline/job/mid-project/  to start application "
echo "Use kubectl get svc to find kandula-app dns address"