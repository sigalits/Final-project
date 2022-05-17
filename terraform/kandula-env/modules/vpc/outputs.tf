output "public_subnets" {
  value = aws_subnet.public
}

#output "database_subnets" {
#  value = aws_subnet.database
#}

output "private_subnets" {
  value = aws_subnet.private
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "common_sg_id" {
  value = aws_security_group.common.id
}

output "eks_cluster_name" {
  value = local.cluster_name
}