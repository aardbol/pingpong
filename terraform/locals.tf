locals {
  regions = {
    default = "eu-central-1"
    tokyo   = "ap-northeast-1"
  }
  environment        = "prod"
  frankfurt_azs      = slice(data.aws_availability_zones.frankfurt.names, 0, 3)
  frankfurt_vpc_cidr = "172.1.0.0/16"
  cluster_name       = "test-eks"

  office_and_vpn_ips = {
    "Office" : "1.1.1.1/32",
    "VPN-EU" : "2.2.2.2/32",
  }
}
