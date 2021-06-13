
data "aws_caller_identity" "caller" {}

module "vpc" {
  source = "./vpc/"
  region = "${var.region}"
  cidr_block = "${var.cidr_block}"
  azs = "${var.azs}"
  public_subnets = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
  tags = "${var.tags}"
}

resource "aws_security_group" "ec2-sg" {
  name = "My EC2 security group"
  description = "My EC2 security group"
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "ec2-sg-rules" {
  count = "${length(var.sg_rules)}"
  from_port = "${lookup(var.sg_rules[count.index], "from_port")}"
  protocol = "${lookup(var.sg_rules[count.index], "protocol")}"
  security_group_id = "${aws_security_group.ec2-sg.id}"
  to_port = "${lookup(var.sg_rules[count.index], "to_port")}"
  type = "${lookup(var.sg_rules[count.index], "type")}"
  cidr_blocks = ["${lookup(var.sg_rules[count.index], "cidr")}"]
}

resource "aws_instance" "my-instance" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  subnet_id = "${module.vpc.public_subnet_ids[0]}"
  vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
}