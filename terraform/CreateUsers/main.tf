# configure provider with proper credentials 
provider "aws" {
  version = "~> 2.33"
  region = "us-west-2"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "default"
} # end provider

terraform {
   backend "s3" {
   region = "us-west-2"
   bucket = "project1-terraform-backend-bucket-alex"
   key    = "IAM/terraform.tfstate"
   dynamodb_table = "project1-terraform-backend-table"
   encrypt = true
  }
}

# get data from caller
data "aws_caller_identity" "current" {}

# create users
resource "aws_iam_user" "users" {
  count = "${length(var.username)}"
  name = "${element(var.username,count.index)}"
}

# create group
resource "aws_iam_group" "group" {
  name = "project1"
}

# assign members to admins group
resource "aws_iam_group_membership" "project1" {
  name = "project1-group-membership"
  count = "${length(var.username)}"
  users = ["${element(var.username,count.index)}"]
  group = "${aws_iam_group.group.name}"
}

# create IAM policy for group
resource "aws_iam_group_policy" "project1policy" {
  name  = "project1-iconnect-policy"
  group = "${aws_iam_group.group.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2-instance-connect:SendSSHPublicKey",
      "Resource": "arn:aws:ec2:us-west-2:${data.aws_caller_identity.current.account_id}:instance/*",
      "Condition": {
        "StringEquals": {
          "ec2:osuser": ["ubuntu", "ec2-user"]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOF
}

# create Lambda role start/stop
resource "aws_iam_role" "lambdarole" {
  name = "project1-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "project-project1"
  }
}

# create IAM policy for lamdba
resource "aws_iam_policy" "project1lambdapolicy" {
  name  = "project1-lambda-policy"
  description = "Allows Lambda functions to call AWS services on your behalf."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# attach policy to role
resource "aws_iam_role_policy_attachment" "lambda-attach" {
  role       = "${aws_iam_role.lambdarole.name}"
  policy_arn = "${aws_iam_policy.project1lambdapolicy.arn}"
}