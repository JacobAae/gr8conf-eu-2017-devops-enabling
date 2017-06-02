//tag::module-input-1[]
variable "host_ami" {
  description = "Ami for the host"
  default = "ami-75cbcb13" // rancheros-v1.0.1-hvm-1
}

variable "host_instance_type" {
  description = "The instance type for the hosts"
  default = "t2.micro"
}

variable "vpc_id" {
  description = "The VPC to launch resources in"
}

variable "name" {
  description = "The cluster name"
}
//end::module-input-1[]

//tag::module-input-2[]
variable "host_subnet_ids" {
  description = "The subnets to launch the hosts in"
}

variable "host_security_group_ids" {
  description = "Additional security groups to apply to hosts"
  default = ""
}

variable "host_root_volume_size" {
  description = "The size of the root EBS volume in GB"
  default = 24
}
variable "loadbalancer_ids" {
  description = "The loadbalancers to attach to the auto scaling group"
  default = ""
}
//end::module-input-2[]

//tag::module-input-3[]
variable "rancher_image" {
  description = "The Docker image to run Rancher from"
  default = "rancher/agent:v1.2.2"
}

variable "rancher_server_url" {
  description = "The URL for the Rancher server (including the version, i.e. rancher.gr8conf.org/v1)"
}

variable "rancher_env_token" {
  description = "The Rancher environment token hosts will join rancher with"
}

variable "rancher_host_labels" {
  description = "Comma separate k=v labels to apply to all rancher hosts"
  default = ""
}
//end::module-input-3[]

//tag::module-input-4[]
variable "min_host_capacity" {
  description = "The miminum capacity for the auto scaling group"
  default = 1
}

variable "max_host_capacity" {
  description = "The maximum capacity for the auto scaling group"
  default = 4
}

variable "desired_host_capacity" {
  description = "The desired capacity for the auto scaling group"
  default = 1
}
//end::module-input-4[]

//tag::module-input-5[]
variable "host_health_check_type" {
  description = "Whether to use EC2 or ELB healthchecks in the ELB"
  default = "EC2"
}

variable "host_health_check_grace_period" {
  description = "The grace period for autoscaling group health checks"
  default = 300
}
//end::module-input-5[]


//tag::module-input-6[]
variable "host_profile" {
  description = "The IAM profile to assign to the instances"
  default = ""
}

variable "host_key_name" {
  description = "The EC2 KeyPair to use for the machine"
}
//end::module-input-6[]


