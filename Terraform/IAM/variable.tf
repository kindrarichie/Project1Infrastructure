variable "admin_user" {
  type    = string
  default = "admin_user"
}

variable "vpc_user" {
  type    = string
  default = "vpc_user"
}

variable "group_name" {
  type    = string
  default = "group_name"
}


variable "username" {
  type = "list"
  default = ["alexcoward","kindra"]
}

# get data from caller
data "aws_caller_identity" "current" {}
