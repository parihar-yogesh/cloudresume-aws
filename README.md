# cloudresume-aws

Serverless personal CV site on AWS, provisioned with Terraform and deployed via GitHub Actions.

## Architecture

Static site hosted on S3 and served through CloudFront. A visitor counter is backed by
API Gateway, Lambda, and DynamoDB. DNS and TLS handled by Route 53 and ACM.

## Status

In development.