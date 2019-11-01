# Establish and configure Project 1 Terraform Locking State in S3


# configure provider with proper credentials 
provider "aws" {
  version = "~> 2.33"
  region = "us-west-2"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "default"
} # end provider


# create an s3 bucket
resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "project1-terraform-backend-bucket-alex"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    Name = "Project 1 S3 backend bucket"
    Environment = "production"
  }
}

# create the dynamoDB table

resource "aws_dynamodb_table" "dynamodb-tf-state-lock" {
  name            = "project1-terraform-backend-table"
  hash_key        = "LockID"
  read_capacity   = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Project 1 DynamoDB tf state locking"
    Environment = "production"
  }
} 

