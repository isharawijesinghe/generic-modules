locals {
  type = lower(var.endpoint_type)
  name = "${var.environment}-${local.type}"
}

resource "aws_api_gateway_rest_api" "main" {
  name        = "${var.environment}-${local.name}"
  description = "${local.type} api gateway for ${local.name}"
  body = jsonencode(var.apigw_body)
  endpoint_configuration { types = [var.endpoint_type] }
  put_rest_api_mode = var.endpoint_type == "PRIVATE" ? "merge" : "overwrite"
  tags = var.tags
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  triggers = { redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body)) }
  lifecycle { create_before_destroy = true }
  depends_on = [aws_api_gateway_rest_api.main]
}

module "apigw_stages" {
  source = "./apigw_stages"
  count  = length(var.stages)
  environment              = var.environment
  name                     = local.name
  apigw_rest_api_id        = aws_api_gateway_rest_api.main.id
  apigw_deployment_id      = aws_api_gateway_deployment.main.id
  cloudwatch_log_group_arn = module.cloudwatch_log_group.arn
  stage                    = var.stages[count.index]
  tags = var.tags
}


# resource "aws_api_gateway_deployment" "api_deployment" {
#   depends_on = [aws_api_gateway_rest_api.this]
#   rest_api_id = aws_api_gateway_rest_api.this.id
#   stage_name  = var.api_stage_name
#   stage_description = "Deployed at ${timestamp()}"
#   lifecycle {
#     create_before_destroy = true
#   }
# }
#
# # Create an API Gateway stage
# resource "aws_api_gateway_stage" "api_stage" {
#   deployment_id = aws_api_gateway_deployment.api_deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.this.id
#   stage_name    = var.api_stage_name
# }