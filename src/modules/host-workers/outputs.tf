output "hosts_security_group" {
  value = "${aws_security_group.worker_sg.id}"
}
