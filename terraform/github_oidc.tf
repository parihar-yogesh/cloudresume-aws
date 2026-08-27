# GitHub Actions OIDC: keyless deploy access for this repo's pipeline.

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

# Trust is limited to the main branch of this repository. The subject uses
# GitHub's immutable numeric IDs for the account and repository, which never
# change even if either is renamed, so matching them exactly is both stable
# and more secure than matching the plain names.
resource "aws_iam_role" "github_actions_deploy" {
  name = "cloudresume-github-actions-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:parihar-yogesh@83363257/cloudresume-aws@1338853392:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# Least privilege: sync the site bucket and invalidate the CDN, nothing else.
resource "aws_iam_role_policy" "github_actions_deploy" {
  name = "cloudresume-deploy"
  role = aws_iam_role.github_actions_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListSiteBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.site.arn
      },
      {
        Sid      = "WriteSiteObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.site.arn}/*"
      },
      {
        Sid      = "InvalidateCdn"
        Effect   = "Allow"
        Action   = ["cloudfront:CreateInvalidation"]
        Resource = aws_cloudfront_distribution.site.arn
      }
    ]
  })
}

output "github_actions_role_arn" {
  description = "Role ARN for the GitHub Actions deploy workflow."
  value       = aws_iam_role.github_actions_deploy.arn
}