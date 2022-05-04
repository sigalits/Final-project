####INTERNET GATEWAY####
resource "aws_internet_gateway" "gateway" {
   vpc_id = module.vpc.vpc_id
   tags = merge(
    {
      "Name" = format("%s-vpc", var.tag_name)
    } )
}


resource "aws_route_table" "public" {
  count = length(module.vpc.public_subnets)
  vpc_id = module.vpc.vpc_id

  tags = merge(
    {
      "Name" = format("%s-public-%s", var.tag_name,count.index)
    } )
   }



 resource "aws_route" "public_route" {
   route_table_id = module.vpc.main_route_table_id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gateway.id

   timeouts {
     create = "5m"
   }
 }

resource "aws_route" "public_internet_gateway_ipv6" {
  count = length(module.vpc.public_subnets)
  route_table_id              =  module.vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  =  aws_internet_gateway.gateway.id
     timeouts {
     create = "5m"
   }
}
