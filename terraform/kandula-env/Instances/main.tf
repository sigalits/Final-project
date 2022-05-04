locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "web-server" {
  source = "../modules/web-server"
  kandula_instance_count = var.kandula_instance_count
  ami_id = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
  allow_cidr_blocks = concat([var.vpc_cidr],["${data.http.myip.body}/32"])
  security_group_kandula = data.terraform_remote_state.vpc.outputs.kandula_sg
  common_security_group_id=module.consul.common_sg_id
  vpc_id = data.aws_vpc.vpc.id
  vpc_cidr = var.vpc_cidr
  ebs_data_size = var.ebs_data_size
  ebs_data_type = var.ebs_data_type
  tag_name = format("%s", "${var.tag_name}-web")
  acl_value = var.acl_value
  bucket_name = var.bucket_name
  force_destroy = var.force_destroy
  create_webservers = var.create_webservers
}

module "database" {
  source = "../modules/db-server"
  db_instance_count = var.db_instance_count
  create_dbservers = var.create_dbservers
  ami_id = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.vpc.outputs.database_subnets[*].id
  cidr_blocks = var.cidr_blocks
  az = local.azs
  vpc_id = data.aws_vpc.vpc.id
  vpc_cidr = var.vpc_cidr
  security_group_database = var.security_group_database
  ebs_data_size = var.ebs_data_size
  ebs_data_type = var.ebs_data_type
  tag_name = format("%s", "${var.tag_name}_database")
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
  security_group_consul = var.security_group_consul
  security_group_common = var.security_group_common
  security_group_consul_lb = var.security_group_consul_lb
  tag_name = format("%s", "${var.tag_name}-consul")
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
  describe_instances_policy = file("${path.module}/iam_policies/describe_instances.json")
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
  security_group_bastion = var.security_group_bastion
  common_security_group_id=module.consul.common_sg_id
  tag_name = format("%s", "${var.tag_name}_bastion")
}






