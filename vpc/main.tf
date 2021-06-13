provider "aws" {
  version = "~> 3.0"
  region = "${var.region}"
}

data "aws_caller_identity" "user" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.cidr_block}"
  tags = "${merge("${var.tags}",
    map("creator","${data.aws_caller_identity.user.id}"))
  }"
}

resource "aws_internet_gateway" "my_vpc_gateway" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags = "${merge("${var.tags}",
    map("creator","${data.aws_caller_identity.user.id}"))
  }"
}

resource "aws_subnet" "public_subnets" {
  count = "${length(var.public_subnets)}"
  cidr_block = "${var.public_subnets[count.index]}"
  vpc_id = "${aws_vpc.my_vpc.id}"
  availability_zone = "${var.azs[count.index]}"
}

resource "aws_subnet" "private_subnets" {
  count = "${length(var.private_subnets)}"
  cidr_block = "${var.private_subnets[count.index]}"
  vpc_id = "${aws_vpc.my_vpc.id}"
  availability_zone = "${var.azs[count.index]}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_vpc_gateway.id}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = "${length(var.public_subnets)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id = "${var.public_subnets[count.index]}"
}

resource "aws_eip" "elastic_ip_for_nat" {
  vpc = true
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = "${aws_eip.elastic_ip_for_nat.id}"
  subnet_id = "${aws_subnet.public_subnets[0].id}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.my_nat_gateway.id}"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count = "${length(var.private_subnets)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
  subnet_id = "${var.private_subnets[count.index]}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vpc_id" {
  value = "${aws_vpc.my_vpc.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.private_subnets[*].id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.public_subnets[*].id}"
}





