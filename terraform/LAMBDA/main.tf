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
   key    = "LAMBDA/terraform.tfstate"
   dynamodb_table = "project1-terraform-backend-table"
   encrypt = true
  }
}

# data from remote state bucket VPC/terraform.tfstate
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
        bucket = "project1-terraform-backend-bucket-alex"
        key    = "VPC/terraform.tfstate"
        region  = "us-west-2"
  }
}

# data from remote state bucket VPC/terraform.tfstate
data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
        bucket = "project1-terraform-backend-bucket-alex"
        key    = "EC2/terraform.tfstate"
        region  = "us-west-2"
  }
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
  name        = "project1-lambda-policy"
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
        "ec2:CreateNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:Describe*",
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

### AWS Lambda function ###
# AWS Lambda API requires a ZIP file with the execution code

data "archive_file" "start_scheduler" {
type        = "zip"
source_file = "./start_instances.py"
output_path = "./start_instances.zip"
}

data "archive_file" "stop_scheduler" {
type        = "zip"
source_file = "./stop_instances.py"
output_path = "./stop_instances.zip"
}

# Lambda defined that runs the Python code with the specified IAM role
resource "aws_lambda_function" "ec2_start_scheduler_lambda" {
filename = "start_instances.zip"
function_name = "start_instances"
role = "${aws_iam_role.lambdarole.arn}"
handler = "start_instances.lambda_handler"
runtime = "python2.7"
timeout = 300
source_code_hash = "${filebase64sha256("./start_instances.zip")}"
#vpc_config {
#    subnet_ids         = [data.terraform_remote_state.vpc.outputs.subnet-pub1, data.terraform_remote_state.vpc.outputs.subnet-pub2, #data.terraform_remote_state.vpc.outputs.subnet-pub3, data.terraform_remote_state.vpc.outputs.subnet-pvt1, #data.terraform_remote_state.vpc.outputs.subnet-pvt2, data.terraform_remote_state.vpc.outputs.subnet-pvt3]
#
#    security_group_ids = [data.terraform_remote_state.ec2.outputs.webserver-sg-id, #data.terraform_remote_state.ec2.outputs.bastion-sg-id]
#  }
}

resource "aws_lambda_function" "ec2_stop_scheduler_lambda" {
filename = "stop_instances.zip"
function_name = "stop_instances"
role = "${aws_iam_role.lambdarole.arn}"
handler = "stop_instances.lambda_handler"
runtime = "python2.7"
timeout = 300
source_code_hash = "${filebase64sha256("./stop_instances.zip")}"
#vpc_config {
#    subnet_ids         = [data.terraform_remote_state.vpc.outputs.subnet-pub1, data.terraform_remote_state.vpc.outputs.subnet-pub2, #data.terraform_remote_state.vpc.outputs.subnet-pub3, data.terraform_remote_state.vpc.outputs.subnet-pvt1, #data.terraform_remote_state.vpc.outputs.subnet-pvt2, data.terraform_remote_state.vpc.outputs.subnet-pvt3]
#
#    security_group_ids = [data.terraform_remote_state.ec2.outputs.webserver-sg-id, #data.terraform_remote_state.ec2.outputs.bastion-sg-id]
#  }
}

### Cloudwatch Events ###
# Event rule: Runs at 8pm during working days
resource "aws_cloudwatch_event_rule" "start_instances_event_rule" {
  name = "start_instances_event_rule"
  description = "Starts stopped EC2 instances"
  schedule_expression = "cron(0 8 ? * MON-FRI *)"
  depends_on = ["aws_lambda_function.ec2_start_scheduler_lambda"]
}

# Runs at 8am during working days
resource "aws_cloudwatch_event_rule" "stop_instances_event_rule" {
  name = "stop_instances_event_rule"
  description = "Stops running EC2 instances"
  schedule_expression = "cron(0 20 ? * MON-FRI *)"
  depends_on = ["aws_lambda_function.ec2_stop_scheduler_lambda"]
}

# Event target: Associates a rule with a function to run
resource "aws_cloudwatch_event_target" "start_instances_event_target" {
  target_id = "start_instances_lambda_target"
  rule = "${aws_cloudwatch_event_rule.start_instances_event_rule.name}"
  arn = "${aws_lambda_function.ec2_start_scheduler_lambda.arn}"
}

resource "aws_cloudwatch_event_target" "stop_instances_event_target" {
  target_id = "stop_instances_lambda_target"
  rule = "${aws_cloudwatch_event_rule.stop_instances_event_rule.name}"
  arn = "${aws_lambda_function.ec2_stop_scheduler_lambda.arn}"
}

# AWS Lambda Permissions: Allow CloudWatch to execute the Lambda Functions
resource "aws_lambda_permission" "allow_cloudwatch_to_call_start_scheduler" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_start_scheduler_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.start_instances_event_rule.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_scheduler" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_stop_scheduler_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.stop_instances_event_rule.arn}"
}