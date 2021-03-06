variable "region" {
  type = "string"
  default = "us-east-1"
}

variable "cidr_block" {
  type = "string"
  default = "10.0.0.0/16"
}

variable "azs" {
  type = "list"
  default = ["us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "public_subnets" {
  type = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type = "list"
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "tags" {
  type = "map"
}