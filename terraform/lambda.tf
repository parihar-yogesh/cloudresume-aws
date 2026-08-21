data "archive_file" "counter" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/build/counter.zip"
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "counter" {
  name               = "cloudresume-counter"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "counter_logs" {
  role       = aws_iam_role.counter.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "counter_ddb" {
  statement {
    actions   = ["dynamodb:UpdateItem"]
    resources = [aws_dynamodb_table.visitors.arn]
  }
}

resource "aws_iam_role_policy" "counter_ddb" {
  name   = "dynamodb-access"
  role   = aws_iam_role.counter.id
  policy = data.aws_iam_policy_document.counter_ddb.json
}

resource "aws_lambda_function" "counter" {
  function_name    = "cloudresume-visitor-counter"
  filename         = data.archive_file.counter.output_path
  source_code_hash = data.archive_file.counter.output_base64sha256
  handler          = "handler.handler"
  runtime          = "python3.12"
  role             = aws_iam_role.counter.arn
  timeout          = 10

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitors.name
    }
  }
}