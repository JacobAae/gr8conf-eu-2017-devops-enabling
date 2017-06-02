/*
    Route 53 Zone for DNS
*/
//tag::dns[]
resource "aws_route53_zone" "gr8conf_domain" {
  lifecycle {
    prevent_destroy = true
  }
  name = "grydeske.org"
}

output "domain_ns_servers" {
  // There are 4 in all
  value = "\n${aws_route53_zone.gr8conf_domain.name_servers.0}\n${aws_route53_zone.gr8conf_domain.name_servers.1}\n${aws_route53_zone.gr8conf_domain.name_servers.2}\n${aws_route53_zone.gr8conf_domain.name_servers.3}\n"
}
//end::dns[]
