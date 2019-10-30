# 
# VARIABLES
# 

variable "username" {
  type = "list"
  default = ["alexcoward","kindra"]
}

# get data from caller
data "aws_caller_identity" "current" {}

variable "account_id" {
  type = "string"
  default = ${data.aws_caller_identity.current.account_id}
}