resource "aws_cloudwatch_log_group" "this" {
  name              = var.name_override == true ? local.name_override_value : local.name
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id
  tags = var.tags
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  count = var.subscription_filter != null ? 1 : 0

  name           = "${local.name}-cloudwatch-log-filter"
  log_group_name = aws_cloudwatch_log_group.this.name

  role_arn        = var.subscription_filter.role_arn
  destination_arn = var.subscription_filter.destination_arn
  filter_pattern  = ""
  distribution    = "Random"
}