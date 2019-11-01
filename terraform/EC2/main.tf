#EC2 Bucket Creation

terraform {
  backend "s3" {
  region = "us-west-2"
  bucket = "project1-terraform-backend-bucket-alex"
  key    = "EC2/terraform.tfstate"
  dynamodb_table = "project1-terraform-backend-table"
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

provider "aws" {
  version = "~> 2.33"
  region = "us-west-2"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "default"
}

/*
#Security Groups
*/
resource "aws_security_group" "server_sg" {
  name        = "server_sg_main"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc-id

  tags = {
    Name = "main_SG"
    tag-key = "project-project1"
  }
}

/*
  Bastion Instance SG
*/
resource "aws_security_group" "bastion" {
  name        = "bastion_sg"
  description = "Allow traffic to pass from the Internet to the Web application instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks_whitelist1}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks_whitelist2}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc-id

  tags = {
    Name = "bastion_sg"
    tag-key = "project-project1"
  }
}

/*
#Bastion Host instance
*/
resource "aws_instance" "Bastion_Host" {
  ami                    = "${var.AMIID}"
  instance_type          = "t2.micro"
  key_name               = "${var.aws_key_name}"
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnet-pub1
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  user_data              = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install -y ansible
sudo apt-get install -y ec2-instance-connect
sudo apt-get install -y awscli
sudo apt-get install -y build-essential libssl-dev libffi-dev python3-dev
sudo apt-get install -y python3-pip
pip3 install ec2instanceconnectcli
EOF
  tags = {
    Name = "Bastion_Host"
    tag-key = "project-project1"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
}

/*
  Bastion_Host Instance EIP
*/
resource "aws_eip" "Bastion_Host_eip" {
  instance = "${aws_instance.Bastion_Host.id}"
  vpc      = true
}

/*
#Web Server 1 instance
*/
resource "aws_instance" "Webserver1" {
  ami                    = "${var.AMIID}"
  instance_type          = "t2.large"
  key_name               = "${var.aws_key_name}"
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnet-pvt2
  vpc_security_group_ids = ["${aws_security_group.server_sg.id}"]

  tags = {
    Name = "Webserver1"
    tag-key = "project-project1"
  }
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ec2-instance-connect
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform Server 1</h1>" | sudo tee /var/www/html/index.html
EOF
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
}

/*
#Web Server 2 instance
*/
resource "aws_instance" "Webserver2" {
  ami                    = "${var.AMIID}"
  instance_type          = "t2.large"
  key_name               = "${var.aws_key_name}"
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnet-pvt3
  vpc_security_group_ids = ["${aws_security_group.server_sg.id}"]

  tags = {
    Name = "Webserver2"
    tag-key = "project-project1"
  }
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y ec2-instance-connect
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform Server 2</h1>" | sudo tee /var/www/html/index.html
EOF
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }
}

/*
#Web Server application elb
*/
resource "aws_alb" "web_elb" {
  name                       = "web-alb"
  internal                   = false
  security_groups            = ["${aws_security_group.server_sg.id}"]
  subnets                    = [data.terraform_remote_state.vpc.outputs.subnet-pub1, data.terraform_remote_state.vpc.outputs.subnet-pub2, data.terraform_remote_state.vpc.outputs.subnet-pub3]
  enable_deletion_protection = false
}

/*
#Web Server target group
*/
resource "aws_alb_target_group" "alb_ws_tgrp" {
  name     = "ws-target-Group"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc-id
  port     = "80"
  protocol = "HTTP"
  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200"
  }
  stickiness {
    type = "lb_cookie"
    # Set cookie duration to one hour (3600s)
    cookie_duration = 3600
  }
}

/*
#Web Server 1 attachement to elb
*/
resource "aws_alb_target_group_attachment" "alb_ws-01_http" {
  target_group_arn = "${aws_alb_target_group.alb_ws_tgrp.arn}"
  target_id        = "${aws_instance.Webserver1.id}"
  port             = 80
}

/*
#Web Server 2 attachment to elb
*/
resource "aws_alb_target_group_attachment" "alb_ws-02_http" {
  target_group_arn = "${aws_alb_target_group.alb_ws_tgrp.arn}"
  target_id        = "${aws_instance.Webserver2.id}"
  port             = 80
}

/*
#Web Server listener for port 80 to 443
*/
resource "aws_alb_listener" "ws_listener_http" {
  load_balancer_arn = "${aws_alb.web_elb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

/*
#Web Server listerner for port 443
*/
resource "aws_alb_listener" "ws_alb_https" {
  load_balancer_arn = "${aws_alb.web_elb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.ssl_certificate_id}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_ws_tgrp.arn}"
    type             = "forward"
  }
}

/*
#Route 53 for www.teamaerial.gq
*/
data "aws_route53_zone" "primary" {
  name = "${var.domain}"
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "www"
  type    = "A"

  alias {
    name                   = "${aws_alb.web_elb.dns_name}"
    zone_id                = "${aws_alb.web_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "tld" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = ""
  type    = "A"

  alias {
    name                   = "${aws_alb.web_elb.dns_name}"
    zone_id                = "${aws_alb.web_elb.zone_id}"
    evaluate_target_health = true
  }
}