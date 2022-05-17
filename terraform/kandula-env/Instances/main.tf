locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  access_key = data.external.secret_json.result["AWS_ACCESS_KEY_ID"]
  secret_key = data.external.secret_json.result["AWS_SECRET_ACCESS_KEY"]
}


resource "aws_instance" "jenkins-node" {
  count = var.jenkins_nodes_count
  private_ip = element(var.jenkins_node_private_ip,count.index)
  ami = var.consul_ami_id
  instance_type               = var.instance_type
  key_name                    = var.jenkins_key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.private_subnets[count.index].id
  iam_instance_profile        = data.terraform_remote_state.vpc.outputs.jenkins_instance_profile_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.common_sg_id, data.terraform_remote_state.vpc.outputs.jenkins_server_sg]
  depends_on                  = [module.bastion, module.eks]
  user_data = templatefile("${path.module}/user_data_jenkins.sh" , {
              eks_cluster = data.terraform_remote_state.vpc.outputs.eks_cluster_name,
              region = var.aws_region,
              access_key = local.access_key,
              secret_key = local.secret_key})
  tags = {
    Name = "jenkins-node-${count.index}"
    consul_agent: "true"
    purpose: "jenkins"
  }
}

module "consul" {
  source = "../modules/consul"
  consul_instance_count = var.consul_instance_count
  create_consul_servers = var.create_consul_servers
  create_consul_lb = var.create_consul_lb
  ami_id = var.consul_ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets[*].id
  public_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets.*.id
  cidr_blocks = var.cidr_blocks
  az = local.azs
  vpc_id = data.aws_vpc.vpc.id
  vpc_cidr = var.vpc_cidr
  lb_arn = data.terraform_remote_state.vpc.outputs.lb_arn
  lb_sg_id = data.terraform_remote_state.vpc.outputs.lb_jenkins_sg_id
  security_group_consul = var.security_group_consul
  common_sg_id = data.terraform_remote_state.vpc.outputs.common_sg_id
  security_group_consul_lb = var.security_group_consul_lb
  tag_name = format("%s", "${var.tag_name}-consul")
  }
module "bastion" {
  source = "../modules/bastion"
  ami_id = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
  cidr_blocks = ["${data.http.myip.body}/32"]
  az = local.azs
  vpc_id = data.aws_vpc.vpc.id
  vpc_cidr = var.vpc_cidr
  attach_instance_profile = module.consul.consul_iam_instance_profile_name
  security_group_bastion = var.security_group_bastion
  common_security_group_id = data.terraform_remote_state.vpc.outputs.common_sg_id
  tag_name = format("%s", "${var.tag_name}_bastion")
}

module "eks" {
  source = "../modules/eks"
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets[*].id
  vpc_id = data.aws_vpc.vpc.id
  tag_name=var.tag_name
  common_security_group_id=data.terraform_remote_state.vpc.outputs.common_sg_id
  cluster_name = data.terraform_remote_state.vpc.outputs.eks_cluster_name
  aws_region = var.aws_region
  vpc_cidr = var.vpc_cidr
}

resource "time_sleep" "wait_90_seconds" {
  depends_on = [module.eks]
  create_duration = "90s"
}
resource "null_resource" "update_kubectl_configuration" {
  depends_on = [time_sleep.wait_90_seconds]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${data.terraform_remote_state.vpc.outputs.eks_cluster_name}"
  }
}


#module "web-server" {
#  source = "../modules/web-server"
#  kandula_instance_count = var.kandula_instance_count
#  ami_id = data.aws_ami.ubuntu-18.id
#  key_name = var.key_name
#  instance_type = var.instance_type
#  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
#  allow_cidr_blocks = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
#  security_group_kandula = data.terraform_remote_state.vpc.outputs.kandula_sg
#  common_security_group_id=data.terraform_remote_state.vpc.outputs.common_sg_id
#  vpc_id = data.aws_vpc.vpc.id
#  vpc_cidr = var.vpc_cidr
#  ebs_data_size = var.ebs_data_size
#  ebs_data_type = var.ebs_data_type
#  tag_name = format("%s", "${var.tag_name}-web")
#  acl_value = var.acl_value
#  bucket_name = var.bucket_name
#  force_destroy = var.force_destroy
#  create_webservers = var.create_webservers
#}
#
#module "database" {
#  source = "../modules/db-server"
#  db_instance_count = var.db_instance_count
#  create_dbservers = var.create_dbservers
#  ami_id = data.aws_ami.ubuntu-18.id
#  key_name = var.key_name
#  instance_type = var.instance_type
#  subnet_ids = data.terraform_remote_state.vpc.outputs.database_subnets[*].id
#  cidr_blocks = var.cidr_blocks
#  az = local.azs
#  vpc_id = data.aws_vpc.vpc.id
#  vpc_cidr = var.vpc_cidr
#  security_group_database = var.security_group_database
#  ebs_data_size = var.ebs_data_size
#  ebs_data_type = var.ebs_data_type
#  tag_name = format("%s", "${var.tag_name}_database")
#}





