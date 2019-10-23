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
  bucket = "your-bucket-name"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

# create the dynamoDB table

resource "aws_dynamodb_table" "dynamodb-tf-state-lock" {
  name            = "your-table-name"
  hash_key        = "LockID"
  read_capacity   = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB tf state locking"
  }
} 

