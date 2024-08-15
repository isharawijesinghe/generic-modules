output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_alias_name" {
  value = aws_lambda_alias.lambda_alias.name
}

output "lambda_alias_arn" {
  value = aws_lambda_alias.lambda_alias.arn
}