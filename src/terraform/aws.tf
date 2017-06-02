//tag::aws-provider[]
provider "aws" {
  region  = "eu-west-1"
  profile = "gr8conf"
  // access_key = "${var.aws_access_key}"
  // secret_key = "${var.aws_secret_key}"
}
//end::aws-provider[]