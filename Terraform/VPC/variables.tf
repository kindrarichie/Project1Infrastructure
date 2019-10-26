

variable "product_name" {
  type        = "string"
  description = "Name of product for display purposes"
}

variable "aws_account_ids" {
  type = "map"

  description = "AWS Account ID"
}

variable shared_credentials_file {
  type        = "string"
  description = "Default shared credentials file"
}

variable shared_credentials_profile {
  type        = "string"
  description = "Default shared credentials profile"
}

variable "workspace_to_environment_map" {
  type = "map"
}

locals {
  tf_environment = lookup(var.workspace_to_environment_map, terraform.workspace, "dev")
  tf_env_initial = substr(local.tf_environment, 0, 1) # get first initial for use in naming convention
  tf_naming_conv = "-project1-${var.aws_region}-${local.tf_environment}"
  tf_aws_acct    = contains(["prod", "staging"], local.tf_environment) ? "prod" : "test"
  aws_account_id = var.aws_account_ids[local.tf_aws_acct]
}

variable aws_region {
  type        = "string"
  description = "AWS region to use"
}

variable vpc_cidr_prefix_map {
  type        = "map"
  description = "First two octets of subnets in VPC"
}

variable ssh_bastion_host {
  type        = "string"
  default     = ""
  description = "IP of bastion host"
}

locals {
  ec2_key_name      = "teamface${local.tf_aws_acct == "-prod" ? "" : "-dev"}-${var.aws_region}"
  vpc_cidr_prefix   = lookup(var.vpc_cidr_prefix_map, local.tf_environment, "172.31")
  s3_devops_assets  = "teamface-devops-assets-${var.aws_region}${local.tf_aws_acct == "prod" ? "" : "-non-prod"}"
  local_path_to_pem = "../../${local.ec2_key_name}.pem"
  tf_project        = "${replace(lower(var.product_name), " ", "-")}-iac"

  resource_tags = {
    tf_workspace = local.tf_environment
    tf_project   = "${lower(local.tf_project)}"
  }

  nat_gateways_to_create = min(var.nat_gateways_qty, length(data.aws_availability_zones.azs_available.names))
}

# default Amazon Linux AMI
variable "aws_linux_amis" {
  type = "map"
}

# default Ubuntu 16.04 Linux AMI
variable "ubuntu_amis" {
  type = "map"
}

variable "elb_account_ids" {
  type = "map"
}

variable "nat_gateways_qty" {
  type        = "string"
  description = "Determines how many NAT Gateways should be created within the VPC for use by the private subnets. Limited to the quantity of private subnets"
}
