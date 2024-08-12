module "cloudwatch_log_group" {
  source = "../cloudwatch/log_group"

  environment = var.environment
  name        = local.name

  service_name = "${var.environment}-${local.name}-apigw-cloudwatch"

  retention_in_days   = var.cloudwatch.logging.retention_in_days
  subscription_filter = var.cloudwatch.logging.subscription_filter
  kms_key_id          = var.cloudwatch.kms_key_arn

  tags = var.tags
}