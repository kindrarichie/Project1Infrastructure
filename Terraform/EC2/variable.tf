

#Region on which the resource is deplyed

variable "region" {
  description = "Region on which the region is deployed"
  default     = "us-west-2"
}


#Common variables accross all the EC2 instances. Key Pair, SSL Key, Domain
#AMI Provided by Team Leader

variable "AMIID" {
  type    = string
  default = "ami-0994c095691a46fb5"
}

#Keypair
variable "Key_pair" {
  type    = string
  default = "take2"
}

#SSL Certificates
variable "ssl_certificate_id" {
  type    = string
  default = "arn:aws:acm:us-west-2:028432695418:certificate/8b8b12dd-0631-44c3-8e2f-29d408046799"
}

#Domain
variable "domain" {
  type    = string
  default = "teamface.xyz"
}

#ip's that can connect to the bastion
variable "cidr_blocks_whitelist" {
  description = "range(s) of incoming IP addresses to whitelist"
  type        = "string"
  default = "75.83.44.24/32"
}
