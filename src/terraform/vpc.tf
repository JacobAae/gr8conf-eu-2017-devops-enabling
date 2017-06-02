/*
  Creates a VPC (Virtual Private Cloud)
*/
//tag::vpc-vpc[]
module "vpc" {
  source               = "github.com/terraform-community-modules/tf_aws_vpc"
  name                 = "${var.name}-vpc"
  cidr                 = "${var.vpc_cidr}"
  private_subnets      = "${var.cidrs_private_subnet}"
  public_subnets       = "${var.cidrs_public_subnets}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  enable_nat_gateway   = "true"

  tags {
    "Terraform" = "true"
    "Environment" = "GR8Conf"
  }
}
//end::vpc-vpc[]



/*
  Security Group for traffic within the VPC
*/
//tag::vpc-inside[]
resource "aws_security_group" "vpc_sg_within" {
  name_prefix = "${var.name}"
  vpc_id = "${module.vpc.vpc_id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true   }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true  }
  lifecycle {
    create_before_destroy = true }
}
//end::vpc-inside[]

/*
  Security Group for web traffic
*/
//tag::vpc-web-traffic[]
resource "aws_security_group" "web_sg" {
  name_prefix = "${var.name}"
  vpc_id = "${module.vpc.vpc_id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0" // Restrict IP range access here
    ]
  }
}
//end::vpc-web-traffic[]


/*
Add NAT gateway for private subnet to reach outside VPC
*/
//tag::vpc-nat[]
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${element(module.vpc.public_subnets, 0)}"
}
//end::vpc-nat[]
