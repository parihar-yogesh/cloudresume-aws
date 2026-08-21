output "site_bucket" {
  description = "Name of the S3 bucket hosting the site"
  value       = aws_s3_bucket.site.bucket
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.site.domain_name
}

output "api_endpoint" {
  description = "Base URL of the visitor counter API"
  value       = aws_apigatewayv2_api.counter.api_endpoint
}