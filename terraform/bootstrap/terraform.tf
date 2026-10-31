terraform {
  required_version = ">= 1.10" # S3 だけで state をロックするのに必要

  backend "s3" {
    bucket       = "kago-tfstate-441541653503-ap-northeast-1-an"
    key          = "bootstrap/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
