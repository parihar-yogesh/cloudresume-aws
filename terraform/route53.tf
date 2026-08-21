resource "aws_route53_zone" "main" {
  name = "yogeshparihar.com"
}

resource "aws_route53_record" "site" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "yogeshparihar.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.yogeshparihar.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

output "nameservers" {
  description = "Set these as the domain nameservers at Hostinger"
  value       = aws_route53_zone.main.name_servers
}