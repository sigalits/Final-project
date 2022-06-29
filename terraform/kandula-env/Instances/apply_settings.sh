#! /bin/bash
BASTION_IP=$(terraform output bastion_ip)
bastion=$(echo ${BASTION_IP} | sed 's/"//g')
echo "BASTION address is " ${bastion}
echo ""
cluster_name=$(terraform output cluster_name)
cluster_name=$(echo ${cluster_name} | sed 's/"//g')
echo "EKS Cluster name is :" ${cluster_name}
alb_jenkins=$(terraform output Jenkins_alb)
#alb_jenkins=$(echo ${alb_jenkins} | sed 's/"//g')
alb_jenkins=$(echo ${alb_jenkins} | awk -F\" '{print $2}')
#consul_alb=$(terraform output consul_alb)
#consul_alb=$(echo ${consul_alb} | awk -F\" '{print $2}')
db_setup_script=$(terraform output db_setup_script | awk -F\" '{print $2}')
rds=$(terraform output rds_endpoint)
rds=$(echo ${rds} | awk -F\" '{print $2}')
rds_port=$(terraform output rds_port)
echo $rds
echo $rds_port


echo "creating ssh/config file...."
mv ~/.ssh/config ~/.ssh/config.save_$$
current_dir=$(pwd)
cat <<EOT > ~/.ssh/config
Host bastion
    StrictHostKeyChecking no
    HostName ${bastion}
    User ubuntu
    UserKnownHostsFile /dev/null
    IdentityFile ${current_dir}/../../initial_config/kandula.pem
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256
    StrictHostKeyChecking accept-new

Host jenkins_server
    HostName 10.0.21.21
    User ubuntu
    IdentityFile ${HOME}/jenkins.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    UserKnownHostsFile=/dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256

Host jenkins_agent1
    HostName 10.0.21.10
    User ubuntu
    IdentityFile ${HOME}/jenkins.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    UserKnownHostsFile=/dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256

Host jenkins_agent2
    HostName 10.0.22.10
    User ubuntu
    IdentityFile ${HOME}/jenkins.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    UserKnownHostsFile=/dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256

Host 10.0.*.*
    User ubuntu
    IdentityFile ${current_dir}/../../initial_config/kandula.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    ForwardAgent yes
    UserKnownHostsFile /dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256
EOT

mv .pgpass ~/
rm .pgpass
echo "Running kanduladb setup script"
timeout 300 ssh bastion -L ${rds_port}:${rds}:${rds_port} -T -N  &
sleep 5
echo "Tunnel connection Connected"
echo "Connecting to db"
psql -h localhost -p ${rds_port} -U master -d kanduladb -a -f ${db_setup_script}
kubectl apply -f '/Users/user/PycharmProjects/Mid-project/kandula_nlb_service_ok.yaml'
kubectl get svc
echo "Use \" kubectl get svc \" to find kandula-app dns address"
echo ""
#echo "Consul Dns is : ${consul_alb}"
#echo ""
echo "For proceeding with Ansible deployment "
echo "cd to ${current_dir}/../../../ansible/consul"
echo "and run ansible-playbook consul_setup.yml"
echo ""
echo ""
echo "Please run Jenkins job "
echo "            jenkins.sigalits.com:8080/job/kandula-build-pipeline/job/mid-project/ "
echo ""
echo ""