region = "ap-south-1"
cidr_block = "172.16.0.0/16"
azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
private_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]

ami_id = "ami-abcdefghi"
instance_type = "t2.small"
key_name = "vinay.pem"
sg_rules = [
  {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    type = "ingress"
    cidr = "0.0.0.0/0"
  },
  {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    type = "egress"
    cidr = "0.0.0.0/0"
  }
]

tags = {
  Name = "My-resources"
}