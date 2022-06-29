locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)
}

resource "aws_db_subnet_group" "kandula-db" {
  name       = format("%s-db-sn-grp", var.tag_name)
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets[*].id

  tags = {
    Name = format("%s-db-sn-grp", var.tag_name)
  }
}


resource "aws_db_instance" "kandula-db" {
  allocated_storage      = var.db_storage
  engine                 = var.db_engine["engine"]
  identifier             = var.instance_name
  engine_version         = var.db_engine["version"]
  instance_class         = var.db_instance_class
  port                   = var.db_port
  name                   = var.instance_name
  username               = local.db_credentials["admin_user"]
  password               = local.db_credentials["admin_password"]
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.kandula-db.name
}

output "kandula_db_endpoint" {
  value = format("%s:%s", aws_db_instance.kandula-db.address, aws_db_instance.kandula-db.port)
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow postgres ports"
  # for project vpc should be from module
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = format("%s-rds-sg", var.tag_name)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_psql_from_common_sg" {
  type                     = "ingress"
  from_port                = aws_db_instance.kandula-db.port
  to_port                  = aws_db_instance.kandula-db.port
  protocol                 = "tcp"
  source_security_group_id = data.terraform_remote_state.vpc.outputs.common_sg_id
  description              = "Allow psql port tcp"
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_psql_from_eks" {
  type                     = "ingress"
  from_port                = aws_db_instance.kandula-db.port
  to_port                  = aws_db_instance.kandula-db.port
  protocol                 = "tcp"
  source_security_group_id = module.eks.all_worker_mgmt_sg_id
  description              = "Allow psql port tcp"
  security_group_id        = aws_security_group.rds_sg.id
}


   resource "aws_route53_record" "database" {
      zone_id = data.aws_route53_zone.selected.id
      name = var.instance_name
      type = "CNAME"
      ttl = "60"
      records = [aws_db_instance.kandula-db.address]
   }
#resource "aws_security_group_rule" "rds_ssh" {
#  type              = "ingress"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
#  description       = "Allow ssh from vpc"
#  security_group_id = aws_security_group.rds_sg.id
#}


resource "local_file" "ansible_psql_role_vars" {
  filename        = var.ansible_psql_role_vars_filepath
  file_permission = "0644"
  sensitive_content = templatefile("${path.module}/../templates/dbvars.tftpl", {
    db_name           = var.instance_name,
    db_host           = aws_db_instance.kandula-db.address,
    db_admin_user     = local.db_credentials["admin_user"],
    db_admin_password = local.db_credentials["admin_password"]
  })
}


resource "local_file" "db_setup_script" {
  filename        = var.db_setup_script_filepath
  file_permission = "0644"
  sensitive_content = templatefile("${path.module}/../templates/setup_db.tftpl", {
    app_user          = local.db_credentials["username"],
    app_user_password = local.db_credentials["password"]
  })
}

resource "local_file" "db_pgpass_script" {
  filename        = var.db_pgpass_file_setup
  file_permission = "0600"
  sensitive_content = templatefile("${path.module}/../templates/pgpass.tftpl", {
    db_name           = var.instance_name,
    db_admin_user     = local.db_credentials["admin_user"],
    db_admin_password = local.db_credentials["admin_password"]
  })
}
