output "id" {
  value = aws_api_gateway_rest_api.main.id
}

output "arn" {
  value = aws_api_gateway_rest_api.main.arn
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.main.execution_arn
}

output "invoke_url" {
  value = aws_api_gateway_deployment.main.invoke_url
}
