//tag::vars1[]
variable "name" {
  description = "The name given to the cluster environment"
  default     = "gr8conf"
}

variable "vpc_cidr" {
  description = "The network CIDR."
  default     = "172.16.0.0/16"
}
//end::vars1[]


//tag::vars2[]
variable "cidrs_public_subnets" {
  description = "The CIDR ranges for public subnets."
  default     = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
}

variable "cidrs_private_subnet" {
  description = "CIDRs for private subnets."
  default     = ["172.16.128.0/24", "172.16.129.0/24", "172.16.130.0/24"]
}
//end::vars2[]

