# Backend configuration 

terraform {
  backend "s3" {
    region                  = "us-west-2"
    bucket                  = "project1-terraform-backend-bucket"
    key                     = "vpc/terraform.tfstate"
    dynamodb_table          = "project1-terraform-backend-table"
    encrypt                 = true #AES-256 encryption
  }
}

provider "aws" {
  version = "~> 2.33"
  region = "us-west-2"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "default"
}
