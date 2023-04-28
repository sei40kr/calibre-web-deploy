terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 4.118.0"
    }
  }

  backend "s3" {
    bucket = "calibre-web-terraform-state-2"
    region = "us-east-1"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "oci" {
  config_file_profile = "DEFAULT"
}
