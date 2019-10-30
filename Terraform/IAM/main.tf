#IAM Bucket Creation

terraform {
   backend "s3" {
   region = "us-west-2"
   bucket = "project1-terraform-backend-bucket"
   key    = "IAM/terraform.tfstate"
   dynamodb_table = "project1-terraform-backend-table"
  }
}

provider "aws" {
  version = "~> 2.33"
  region = "us-west-2"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "default"
}
### Creating admin User

resource "aws_iam_user" "admin_user" {
  name = "${var.admin_user}"
  
  tags = {
    tag-key = "project-project1"
  }
  
}

### Creating vpc User

resource "aws_iam_user" "vpc_user" {
  name = "${var.vpc_user}"
  
  tags = {
    tag-key = "project-project1"
  }
  
}

### Creating admin access to admin User

resource "aws_iam_user_policy" "admin_user" {
  name = "admin_access"
  user = "${aws_iam_user.admin_user.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
  ]
}
EOF
}

### Creating vpc fullaccess to vpc User

resource "aws_iam_user_policy" "vpc_user" {
  name = "vpc_access"
  user = "${aws_iam_user.vpc_user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
    ]
}
EOF
}

### Creating developers groups

resource "aws_iam_group" "developers" {
  name = "${var.group_name}"
  path = "/users/"
  
}

### Adding users to developer groups
resource "aws_iam_group_membership" "developers" {
  name = "developers"

  users = [
    "${aws_iam_user.vpc_user.name}",
    "${aws_iam_user.admin_user.name}",
  ]

  group = "${aws_iam_group.developers.name}"
}

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




output "admin_user" {
  value = aws_iam_user.admin_user.name
}

output "vpc_user" {
  value = aws_iam_user.vpc_user.name
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