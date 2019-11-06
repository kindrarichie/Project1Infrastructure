# Project1 Locking Remote State

This file will establish and configure remote state. The Project 1 Terraform remote backend uses AWS Simple Storage Service (S3). 
S3 will allow you to track state over time without worrying about one person overwriting the work of another.
It also uses AWS DynamoDB to lock changes from happening from multiple people at the same time. 

## Dependencies

An AWS account along with the associated credentials. Permissions in AWS allowing AmazonS3FullAccess and AmazonDynamoDBFullAccess.
Terraform installed locally.

## Installation

If not cloning the repo, create a directory with the main.tf file. Run terraform apply. This creates the bucket and lock.
Next, add the following to the top of the file:

    terraform {
    backend  "s3" {
    region         = "us-west-2"
    bucket         = "your-bucket-name"
    key            = "terraform.tfstate"
    dynamodb_table = "your-table-name"
     }
    }
    
Run terraform apply to apply the changes.

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also welcome. To submit a PR, first create a fork of this Github project. Then create a topic branch for the suggested change and push that branch to your own fork.

## Contributors

Alexander Coward (maintainer)

Kindra Richie
