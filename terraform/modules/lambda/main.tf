locals {
  name = "${var.environment}-${var.lambda_function_name}"
  alias_name = "${var.environment}-${var.lambda_function_name}-alias"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.name
  handler       = var.lambda_function_handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  filename         = var.lambda_file_location
  source_code_hash = filebase64sha256(var.lambda_file_location)
  role  = aws_iam_role.lambda_role.arn

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [
      {}
    ]
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = [var.vpc_config.security_group_id]
    }
  }

  environment {
    variables = merge(var.lambda_environment_variables)
  }

}

resource "aws_lambda_alias" "lambda_alias" {
  name             = local.alias_name
  function_name    = aws_lambda_function.lambda.arn
  function_version = "$LATEST"
}
