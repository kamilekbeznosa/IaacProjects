terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-kamilekbeznosa-portfolio"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "../../modules/vpc"

  env                  = "dev"
  region               = "eu-central-1"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_a_cidr = "10.0.1.0/24"
  public_subnet_b_cidr = "10.0.2.0/24"
}

module "compute" {
  source = "../../modules/compute"

  env       = "dev"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_a_id
}

module "alb" {
  source = "../../modules/alb"

  env         = "dev"
  vpc_id      = module.vpc.vpc_id
  subnet_a_id = module.vpc.public_subnet_a_id
  subnet_b_id = module.vpc.public_subnet_b_id
  instance_id = module.compute.instance_id
}

module "lambda_cron" {
  source = "../../modules/lambda"

  env = "dev"
}

module "storage" {
  source = "../../modules/storage"
  env    = "dev"
}

