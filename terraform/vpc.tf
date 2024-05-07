data "aws_availability_zones" "frankfurt" {
  state = "available"
}

module "vpc_frankfurt" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"

  name             = "Test"
  cidr             = local.frankfurt_vpc_cidr
  azs              = local.frankfurt_azs
  private_subnets  = [for k, v in local.frankfurt_azs : cidrsubnet(local.frankfurt_vpc_cidr, 6, k)]
  public_subnets   = [for k, v in local.frankfurt_azs : cidrsubnet(local.frankfurt_vpc_cidr, 6, k + 3)]
  intra_subnets    = [for k, v in local.frankfurt_azs : cidrsubnet(local.frankfurt_vpc_cidr, 6, k + 6)]
  database_subnets = [for k, v in local.frankfurt_azs : cidrsubnet(local.frankfurt_vpc_cidr, 6, k + 9)]

  enable_nat_gateway                              = true
  create_database_subnet_route_table              = true
  enable_ipv6                                     = true
  public_subnet_assign_ipv6_address_on_creation   = true
  private_subnet_assign_ipv6_address_on_creation  = true
  intra_subnet_assign_ipv6_address_on_creation    = true
  database_subnet_assign_ipv6_address_on_creation = true

  private_subnet_ipv6_prefixes  = [0, 1, 2]
  public_subnet_ipv6_prefixes   = [3, 4, 5]
  intra_subnet_ipv6_prefixes    = [6, 7, 8]
  database_subnet_ipv6_prefixes = [9, 10, 11]

  default_security_group_ingress = concat([
    for k, v in local.office_and_vpn_ips : {
      description = k
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = v
    }
    ], [{
      description = "Internal"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
  }])

  default_security_group_egress = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
    }, {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = "::/0"
  }]

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
