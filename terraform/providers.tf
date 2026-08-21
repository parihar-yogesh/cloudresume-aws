provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "cloudresume-aws"
      ManagedBy = "terraform"
    }
  }
}