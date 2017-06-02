/*
Launch configuration for the rancher workers
*/
//tag::workers1a[]
resource "aws_launch_configuration" "worker" {
  name_prefix = "terraform_worker_"
  image_id = "${var.host_ami}"
  instance_type = "${var.host_instance_type}"
  iam_instance_profile = "${var.host_profile}"
  security_groups = [
    "${compact(concat(list(aws_security_group.worker_sg.id), split(",", var.host_security_group_ids)))}"
  ]
  associate_public_ip_address = false
  ebs_optimized = false // To enable tiny instances
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.host_root_volume_size}"
    delete_on_termination = true
  }
  //end::workers1a[]
  //tag::workers1b[]
  user_data = <<EOF
#cloud-config
rancher:
  services:
    rancher-agent1:
      image: ${var.rancher_image}
      environment:
        - CATTLE_AGENT_IP=$private_ipv4
        - CATTLE_HOST_LABELS=${join("&", split(",", var.rancher_host_labels))}
      command: ${var.rancher_server_url}/scripts/${var.rancher_env_token}
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
      privileged: true
EOF
  lifecycle {
    create_before_destroy = true
  }
}
//end::workers1b[]

/*
 Autoscaling Group for rancher workers
*/
//tag::workers2[]
resource "aws_autoscaling_group" "rancher" {
  max_size = "${var.max_host_capacity}"
  min_size = "${var.min_host_capacity}"
  desired_capacity = "${var.desired_host_capacity}"
  launch_configuration = "${aws_launch_configuration.worker.id}"
  health_check_type = "${var.host_health_check_type}"
  health_check_grace_period = "${var.host_health_check_grace_period}"
  load_balancers = [ "${compact(split(",", var.loadbalancer_ids))}" ]
  vpc_zone_identifier = [
    "${split(",", var.host_subnet_ids)}"
  ]
  tag {
    key = "Name"
    value = "${var.name}-host"
    propagate_at_launch = true
  }
}
//end::workers2[]

/*
Security Group for Rancher Host cluster communication
*/
//tag::workers3[]
resource "aws_security_group" "worker_sg" {
  description = "Allow traffic to worker instances"
  vpc_id = "${var.vpc_id}"
}
//end::workers3[]

/*
The following rules are to enable the IPSec networking within the cluster.
They should NOT be changed.
*/
//tag::workers4[]
resource "aws_security_group_rule" "rancher_upd_500_ingress" {
  type = "ingress"
  from_port = 500
  to_port = 500
  protocol = "udp"
  security_group_id = "${aws_security_group.worker_sg.id}"
  self = true
}

resource "aws_security_group_rule" "rancher_upd_4500_ingress" {
  type = "ingress"
  from_port = 4500
  to_port = 4500
  protocol = "udp"
  security_group_id = "${aws_security_group.worker_sg.id}"
  self = true
}
//end::workers4[]

//tag::workers5[]
resource "aws_security_group_rule" "rancher_upd_500_egress" {
  type = "egress"
  from_port = 500
  to_port = 500
  protocol = "udp"
  security_group_id = "${aws_security_group.worker_sg.id}"
  self = true
}

resource "aws_security_group_rule" "rancher_upd_4500_egress" {
  type = "egress"
  from_port = 4500
  to_port = 4500
  protocol = "udp"
  security_group_id = "${aws_security_group.worker_sg.id}"
  self = true
}
//end::workers5[]


/*
Additional rule for configuring outbound network connections.
This will likely need to be 0.0.0.0/0 so pulling images and any
other normal things are possible.
This can still be global outbound, but routed through a NAT
in your VPC.
*/
//tag::workers6[]
resource "aws_security_group_rule" "rancher_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.worker_sg.id}"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}
//end::workers6[]
