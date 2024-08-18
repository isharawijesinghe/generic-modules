resource "aws_api_gateway_stage" "stage" {
  deployment_id        = var.apigw_deployment_id
  rest_api_id          = var.apigw_rest_api_id
  stage_name           = var.stage.name
  xray_tracing_enabled = var.stage.xray_tracing_enabled
  tags = var.tags
}

# resource "aws_api_gateway_method_settings" "method_settings" {
#   rest_api_id = var.apigw_rest_api_id
#   stage_name  = aws_api_gateway_stage.stage.stage_name
#   method_path = "*/*"
#
#   settings {
#     metrics_enabled      = var.stage.method_settings.metrics_enabled
#     logging_level        = var.stage.method_settings.logging_level
#     caching_enabled      = var.stage.method_settings.caching_enabled
#     cache_data_encrypted = var.stage.method_settings.cache_data_encrypted
#   }
#
#   depends_on = [aws_api_gateway_stage.stage]
# }
#
# resource "aws_api_gateway_usage_plan" "usage_plan" {
#   count = var.stage.throttle_enabled ? 1 : 0
#   name = "${var.environment}-${var.name}-usage-plan"
#
#   api_stages {
#     api_id = var.apigw_rest_api_id
#     stage  = aws_api_gateway_stage.stage.stage_name
#   }
#
#   throttle_settings {
#     burst_limit = var.stage.throttle_settings.burst_limit
#     rate_limit  = var.stage.throttle_settings.rate_limit
#   }
# }

resource "aws_api_gateway_vpc_link" "vpc_link" {
  count       = var.stage.vpc_link_name != null ? 1 : 0
  name        = var.stage.vpc_link_name
  target_arns = var.stage.vpc_links_target_arns
}
