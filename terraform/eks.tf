module "eks_eu_test" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name             = local.cluster_name
  cluster_version          = "1.31"
  vpc_id                   = module.vpc_frankfurt.vpc_id
  subnet_ids               = module.vpc_frankfurt.private_subnets
  control_plane_subnet_ids = module.vpc_frankfurt.intra_subnets
  enable_irsa              = true

  enable_cluster_creator_admin_permissions = true

  iam_role_name                  = local.cluster_name
  cluster_endpoint_public_access = true
  # TODO: configure this to the right IPs to allow only specific IPs from connecting to the control plane
  #  cluster_endpoint_public_access_cidrs = values(local.office_and_vpn_ips)

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
        }
      })
    }
  }

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  eks_managed_node_group_defaults = {
    ami_type = "BOTTLEROCKET_x86_64"
    platform = "bottlerocket"

    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned",
    }
  }

  eks_managed_node_groups = {
    default_node_group = {
      use_custom_launch_template = false

      disk_size = 50

      remote_access = {
        ec2_ssh_key               = aws_key_pair.default.key_name
        source_security_group_ids = [module.vpc_frankfurt.default_security_group_id]
      }
    }
  }

  tags = {
    Environment = "test"
  }
}
