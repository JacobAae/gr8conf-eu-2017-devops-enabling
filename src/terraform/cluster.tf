/*
  Worker hosts for the cluster
*/
//tag::cluster-hosts[]
module "hosts" {
  source = "../modules/host-workers"
  name = "${var.name}-cluster"
  desired_host_capacity="2"
  host_key_name = "recovery"
  vpc_id = "${module.vpc.vpc_id}"
  host_subnet_ids = "${join(",", module.vpc.private_subnets)}"
  rancher_server_url = "https://rancher.grydeske.com/v1"
  rancher_env_token = "D93C1B9F627E1B7168AE:1483142400000:7lZFwjs9lDSQskK9fbXCPwiPL2g"
  rancher_host_labels = "region=eu-west-1,type.app=true,type.network=true"
  loadbalancer_ids = "${aws_elb.cluster-elb-public.id}"
  host_security_group_ids = "${aws_security_group.vpc_sg_within.id}"
  host_ami = "ami-75cbcb13"
}
//end::cluster-hosts[]


/*
  Web traffic to the Rancher server instance
*/
//tag::cluster-elb[]
resource "aws_elb" "cluster-elb-public" {
  subnets = ["${module.vpc.public_subnets}"]
  security_groups = [ "${aws_security_group.web_sg.id}", "${aws_security_group.vpc_sg_within.id}" ]
  listener {
    lb_port = 80
    lb_protocol = "HTTP"
    instance_port = 80
    instance_protocol = "HTTP"  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "TCP:80"
    interval = 10 }
  cross_zone_load_balancing = true
  tags { Cluster = "${var.name}"  }
}
//end::cluster-elb[]


//tag::cluster-dns[]
resource "aws_route53_record" "dns-wildcard" {
  name = "*"
  zone_id = "${aws_route53_zone.gr8conf_domain.id}"
  type = "A"
  alias {
    name = "${aws_elb.cluster-elb-public.dns_name}"
    zone_id = "${aws_elb.cluster-elb-public.zone_id}"
    evaluate_target_health = true
  }
}
//end::cluster-dns[]
