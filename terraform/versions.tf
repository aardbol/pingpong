terraform {
  required_version = ">=1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50"
    }
  }
}

provider "aws" {
  region = local.regions.default

  default_tags {
    tags = {
      Environment = local.environment
    }
  }
}
