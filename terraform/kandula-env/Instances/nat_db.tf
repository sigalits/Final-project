###NAT Gateway###

#resource "aws_eip" "nat_db" {
#  count = var.create_dbservers ? length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id) : 0
#  vpc = true
#  tags = {
#    "Name" = format(  "%s-%s", var.tag_name, local.azs[count.index] )
#  }
#}

#resource "aws_nat_gateway" "natgw_db" {
#  count =  var.create_dbservers ? length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id) : 0
#  allocation_id = aws_eip.nat_db[count.index].id
#  subnet_id =data.terraform_remote_state.vpc.outputs.public_subnets[count.index].id
#
#  tags = {
#      "Name" = format(
#        "%s-database-%s",
#        var.tag_name,
#        local.azs[count.index])
#    }

# }

resource "aws_route_table" "database" {
  count =  var.create_dbservers ? length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id) : 0
  vpc_id = data.aws_vpc.vpc.id
  tags =  {
      "Name" = "${var.tag_name}-database-${count.index}"
    }
}


resource "aws_route" "database_nat_gateway" {
  count =  var.create_dbservers ? length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id) : 0
  route_table_id         = aws_route_table.database[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw_private.*.id, count.index)

  timeouts {
    create = "5m"
  }
}
resource "aws_route_table_association" "db_nat_gateway" {
  count =  var.create_dbservers ? length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id) : 0
  subnet_id = data.terraform_remote_state.vpc.outputs.database_subnets[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}