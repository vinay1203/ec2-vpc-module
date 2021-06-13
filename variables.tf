variable "region" {
  type = "string"
}

variable "cidr_block" {
  type = "string"
}

variable "azs" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "ami_id" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "sg_rules" {
  type = "list"
}

variable "tags" {
  type = "map"
}
