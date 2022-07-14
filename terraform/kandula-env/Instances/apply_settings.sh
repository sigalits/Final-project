#! /bin/bash
#echo "The script you are running has basename $( basename -- "$0"; ), $( dirname -- "$( readlink -f -- "$0"; )"; )"
scriptdir="$(dirname "$(realpath "$0")")"
TOP_DIR=`echo ${scriptdir} | awk -F "terraform" '{print $1}'`
export HELM_DIR=${TOP_DIR}/helm

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
    IdentityFile ${TOP_DIR}/terraform/initial_config/kandula.pem
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
    IdentityFile ${TOP_DIR}/terraform/initial_config/kandula.pem
    ProxyJump bastion
    StrictHostKeyChecking accept-new
    ForwardAgent yes
    UserKnownHostsFile /dev/null
    HostKeyAlgorithms=ecdsa-sha2-nistp256
    FingerprintHash=sha256
EOT

if [ "${rds}X" != "X" ];
 then
  mv .pgpass ~/
  rm .pgpass
  echo "Running kanduladb setup script"
  timeout 300 ssh bastion -L ${rds_port}:${rds}:${rds_port} -T -N  &
  sleep 5
  echo "Tunnel connection Connected"
  echo "Connecting to db"
  psql -h localhost -p ${rds_port} -U master -d kanduladb -a -f ${db_setup_script}
  kubectl apply -f '/Users/user/PycharmProjects/Final-project/kandula_nlb_service_ok.yaml'
  kubectl get svc
  echo "Use \" kubectl get svc \" to find kandula-app dns address"
  echo ""
fi
#echo "Consul Dns is : ${consul_alb}"
#echo ""
echo "For proceeding with Ansible deployment "
echo "cd to ${TOP_DIR}/ansible"
cd  ${TOP_DIR}/ansible/
echo "and run ansible-playbook consul_setup.yml"
ansible-playbook final_project.yaml
echo ""
echo ""
echo "Please run Jenkins job "
echo "            jenkins.sigalits.com:8080/job/kandula-build-pipeline/job/mid-project/ "
echo ""
echo ""
cd ${HELM_DIR}

kubectl create ns monitoring
kubectl create ns grafana
kubectl create ns consul
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts -n monitoring
helm repo add grafana https://grafana.github.io/helm-charts -n grafana
helm repo add hashicorp https://helm.releases.hashicorp.com -n consul
helm repo update
echo "helm install prometheus"
helm show values prometheus-community/prometheus > ${HELM_DIR}/prom_values.yaml
helm install prometheus prometheus-community/prometheus --namespace monitoring -f ${HELM_DIR}/prom_values.yaml

export POD_PROM=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
echo "To expose prometheus  use : kubectl --namespace monitoring port-forward $POD_PROM 9090 & "
alias ExposeProm=' kubectl --namespace monitoring port-forward $POD_PROM 9090'

echo "helm install Grafana"
helm install grafana grafana/grafana -n grafana -f ${HELM_DIR}/grafana_values.yaml
##echo " Grafana admin Password is $(kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ) "
#kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
export POD_GRAF=$(kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
echo "Modifing Grafana password"
kubectl exec -i -t -n ${POD_GRAF} -it -- sh -c "grafana-cli admin reset-admin-password admin"

echo "To expose Grafana use : kubectl --namespace grafana port-forward $POD_GRAF 3000 &"
alias ExposeGraf='kubectl --namespace grafana port-forward ${POD_GRAF} 3000'

#alias Cleanup_kube= 'kubectl delete daemonsets,replicasets,services,deployments,pods,rc,ingress --all --all-namespaces'
alias Destroy='terraform destroy '
alias Pods='kubectl get pods --all-namespaces '
alias Svc='kubectl get svc --all-namespaces '
echo "create secret for gossip"
kubectl create secret generic consul-gossip-encryption-key --from-literal=key="uDBV4e+LbFW3019YKPxIrg==" -n consul

echo "helm install Consul"
helm install consul hashicorp/consul -n consul -f ${HELM_DIR}/consul_values.yaml

echo "Configure CoreDns resolve configmap"
export CONSUL_DNS_IP=`kubectl get svc consul-consul-dns -n consul --output jsonpath='{.spec.clusterIP}'`
echo Consul service appears at address = $CONSUL_DNS_IP
envsubst < ${HELM_DIR}/coredns_configmap.tmpl > ${HELM_DIR}/coredns_configmap.yaml
kubectl apply -f ${HELM_DIR}/core_dns_config_map.yaml



