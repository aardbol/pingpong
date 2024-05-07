data "aws_security_group" "default" {
  vpc_id = module.vpc_frankfurt.vpc_id
  name   = "default"
}

resource "aws_key_pair" "default" {
  key_name   = "default-admin"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsWfWaXtUYiORjn2oA/F98lKD65LsG7ZPq2MtyV3xZS"
}