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

##SSL Certificates
variable "ssl_certificate_id" {
  type    = string
  default = "arn:aws:acm:us-west-2:862576949950:certificate/5c18a444-f947-4e40-bf73-7424c885fe70"
}

#Domain
variable "domain" {
  type    = string
  default = "teamaerialcsun.gq"
}

#ip's that can connect to the bastion
variable "cidr_blocks_whitelist1" {
  description = "range(s) of incoming IP addresses to whitelist"
  type        = string
  default = "75.83.44.24/32"
}

#ip's that can connect to the bastion
variable "cidr_blocks_whitelist2" {
  description = "range(s) of incoming IP addresses to whitelist"
  type        = string
  default = "107.184.247.219/32"
}

variable "aws_key_name" {
  type        = "string"
  description = "Key Pair"
  default     = "testing"
}