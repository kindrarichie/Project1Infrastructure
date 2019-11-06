# Project1 IAM

These Terraform files will configure IAM in an AWS account enabling management of access to AWS services and resources securely. 

This establishes the following in IAM:

- Two users
- One group, project1, that the two users belong to
- One managed policy granting users permission for EC2 Instance Connect applied to the project1 group

## Dependencies

An AWS account along with the associated credentials and an [S3 backend resource](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/SetupTerraformBackend). 
Permissions in AWS allowing IAMFullAccess and AmazonS3FullAccess.
Terraform installed locally.

## Installation

Change the usernames in variable.tf to your preferred users. Run terraform plan and then apply. Optionally, first create a new directory for all three files depending on the file layout your prefer. If creating a new directory, be sure to change the key for the backend resource. 

## Inputs

| Name | Description | Type |
|------|-------------|:----:|
| username | Names of users | list |

## Outputs

| Name | Description |
|------|-------------|
| username | Names of users |

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also welcome. To submit a PR, first create a fork of this Github project. Then create a topic branch for the suggested change and push that branch to your own fork.

## Contributors

Alexander Coward (maintainer)

Kindra Richie
