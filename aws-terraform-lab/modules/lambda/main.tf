data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/cost_reporter.py"
  output_path = "${path.module}/cost_reporter.zip"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.env}-cost-reporter-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "cost_reporter" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.env}-aws-cost-reporter"
  role             = aws_iam_role.lambda_role.arn
  handler          = "cost_reporter.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.10"

  tags = {
    Name = "${var.env}-lambda"
  }
}

resource "aws_cloudwatch_event_rule" "daily_schedule" {
  name                = "${var.env}-daily-cost-report"
  description         = "Trigger cost reporter lambda daily"
  schedule_expression = "cron(0 8 * * ? *)"
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.daily_schedule.name
  target_id = "cost_reporter_lambda"
  arn       = aws_lambda_function.cost_reporter.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cost_reporter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_schedule.arn
}