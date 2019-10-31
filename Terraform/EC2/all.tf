data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
        bucket = "project1-terraform-backend-bucket"
        key    = "VPC/terraform.tfstate"
        region  = "us-west-2"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "project1-terraform-backend-bucket"
    key    = "IAM/terraform.tfstate"
    region = "us-west-2"
  }
}
