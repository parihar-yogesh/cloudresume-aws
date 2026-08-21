variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-central-1"
}

variable "site_bucket_name" {
  description = "Globally-unique S3 bucket name for the static site"
  type        = string
  default     = "cloudresume-site-yparihar"
}