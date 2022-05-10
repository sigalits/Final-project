locals {
  cluster_name = "${var.tag_name}-eks"
}

resource "aws_vpc" "vpc" {
  cidr_block       =  var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true   # gives you an internal domain name
  enable_dns_hostnames = true # gives you an internal host name
  enable_classiclink = false


     tags = merge(
    {
      "Name" = format("%s", "${var.tag_name}-vpc")
    },
    {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
    )
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
  {
    "Name" = format("%s-public-%s", var.tag_name, var.azs[count.index])
  },
  {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  },
  {
    "kubernetes.io/role/elb" = "1"
  }
  )
}



##################
# Database subnet
##################
resource "aws_subnet" "database" {
  count =  length(var.database_subnets)

  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = var.database_subnets[count.index]
  availability_zone               = var.azs[count.index]

  tags ={ "Name" = format(  "%s-database-%s",  var.tag_name,  var.azs[count.index],)
    }
 }

##################
# private subnet
##################
resource "aws_subnet" "private" {
  count =  length(var.private_subnets)

  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = var.private_subnets[count.index]
  availability_zone               = var.azs[count.index]

  tags = merge(
        {
          "Name" = format("%s-private-%s",  var.tag_name,  var.azs[count.index],)
        },
        {
          "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        },
        {
          "kubernetes.io/role/internal-elb"             = "1"
        }
    )
}




