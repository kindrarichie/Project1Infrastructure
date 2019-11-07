# Project1 Lambda

These Terraform files will use AWS CloudWatch service to trigger AWS Lambda to stop and start Amazon EC2 instances at regular intervals.   

This establishes the following:

- An IAM policy attached to a role for the Lambda service 
- Lambda functions that stop and start the EC2 instances (a bastion and two web servers tagged AutoOnOff). The runtime is Python 2.7
- Rules that trigger the Lambda functions. The instances are started at 8pm Mon-Fri. The instances are stopped at 8am Mon-Fri
- Rule association with the Lambda functions
- AWS Lambda Permissions allowing CloudWatch to execute the Lambda functions

## Dependencies

An AWS account along with the associated credentials and an [S3 backend resource](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/SetupTerraformBackend). 
Terraform installed locally. 
[The provisioned VPC](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/VPC). 
[The provisioned EC2 infrastructure](https://github.com/alexcoward/Project1Infrastructure/tree/master/terraform/EC2).

## Installation

Run terraform plan and then apply. Optionally, first create a new directory for all the files depending on the file layout your prefer. If creating a new directory, be sure to change the key for the backend resource. 

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also welcome. To submit a PR, first create a fork of this Github project. Then create a topic branch for the suggested change and push that branch to your own fork.

## Contributors

Alexander Coward (maintainer)

Kindra Richie
