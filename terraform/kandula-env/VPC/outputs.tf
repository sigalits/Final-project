output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}


output "main_route_table_id" {
  value = module.vpc.main_route_table_id
}

output "kandula_sg" {
  value = aws_security_group.kandula-sg.id
}