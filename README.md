# Mid-project
Environment for OpsSchool project

Pre-requisites
Terraform and ansible installed on local machine or machine to which this repo was cloned.
To verify kube deployment kubectl need to be installed also. 

This configuration makes use of a public, simple, vpc module that provisions a vpc with 2 private and 2 public subnets. if you opt for using a different vpc module or provision on your own please update vpc.tf accordingly.

The application will run with a dedicated app user credentials. This IAM user is expected to be pre-provisioned before applying this configuration.
Its credentials should be stored/updated in aws as secrets as base64 mask under secret_name : aws_keys_kandula

please, Set local admin credentials for applying the environment at .aws/credential or configure  variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY 


1) Install Kubectl:
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

2) Create s3 bucket to hold the state of the configuration and ssh pem key for ec2 instances:

cd terraform/initial_config
tf init
tf apply --auto-approve


Provision the project environment 
3) Creating VPC / subnets/ common_sg/ jenkins server 

cd ../kandula_env/VPC

⚠️ The creation of jenkins file requires existing key pair called  "sigal_jenkins_ec2_key" and ssh key file $home/jenkins.key
   please use variable jenkins_key to override this key .

terraform init
terraform apply --auto-approve

4) Creating Consul / Jenkins nodes/ eks / bastion

cd ../Instances
terraform apply --auto-approve

5) setting ssh/.ssh_config for anisble provisioning
 in ../Instances/apply_settings.sh

6) Instance provisioning for consul servers and consul agents
install ansible dependencies

cd ../../ansible/consul
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.docker

Run the ansible playbook
ansible-playbook consul_setup.yml

# Adjustment
1. Update current Jenkins url on GitHub app : https://github.com/settings/installations/25674329
2. If Jenkins node key changed please update Jenkins server with new credentials

# Known issues:
When applying terraform in some cases there's an issue with default tags. a consecutive apply usually resolves the issue.
Error: Provider produced inconsistent final plan
When expanding the plan for <some resource> to include new values learned so far during apply, provider "registry.terraform.io/hashicorp/aws" produced an
invalid new value for .tags_all: new element "Name" has appeared. 
This is a bug in the provider, which should be reported in the provider's own issue tracker.
Another option is to disable default_tags in providers.tf file. with this, though, you should keep in mind only "Name" tags will be set for some of the resources provisioned by this configuration.
Thanks!
