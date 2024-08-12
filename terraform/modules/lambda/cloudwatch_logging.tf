module "cloudwatch_log_group" {
  source = "../../cloudwatch/log_group"

  environment = var.environment
  name        = "${local.name}-log-group"

  service_name = "lambda"

  retention_in_days   = try(var.cloudwatch.logging.retention_in_days, 90)
  subscription_filter = try(var.cloudwatch.logging.subscription_filter, null)
  kms_key_id          = try(var.cloudwatch.logging.kms_key_id, null)
  tags = var.tags
}

resource "aws_cloudwatch_log_metric_filter" "error_log_event_metric_filter" {
  count = try(var.cloudwatch.alarms.log_event_error_threshold, null) == null ? 0 : 1

  name    = "${local.name}-error-log-event-metric-filter"
  pattern = coalesce(var.cloudwatch.alarms.log_event_error_pattern, "\"[ERROR]\"")

  log_group_name = module.cloudwatch_log_group.name

  metric_transformation {
    name      = "${local.name}-error-log-event"
    namespace = "${local.name}/LogErrors"
    value     = "1"
  }

  depends_on = [module.cloudwatch_log_group]
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_firehose_stream" {
  count           = try(var.cloudwatch.datadog_logging_integrations, null) == null ? 0 : 1
  name            = "${local.name}-datadog-firehose-stream"
  destination_arn = var.cloudwatch.datadog_logging_integrations.destination_arn
  filter_pattern  = var.cloudwatch.datadog_logging_integrations.filter_pattern
  log_group_name  = module.cloudwatch_log_group.name
  role_arn        = var.cloudwatch.datadog_logging_integrations.role_arn
  distribution    = var.cloudwatch.datadog_logging_integrations.distribution

  depends_on = [module.cloudwatch_log_group]
}
