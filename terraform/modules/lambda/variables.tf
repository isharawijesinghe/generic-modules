variable "environment" {}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "lambda_function_handler" {}

variable "lambda_file_location" {}

variable "tags" { type = map(string) }

variable "enable_lambda_inside_vpc" {
  type    = bool
  default = true  # or false, based on your requirement
}


variable "runtime" {}
variable "timeout" {}
variable "memory_size" {}

variable "environment_variables" {
  description = "A map of environment variables to pass to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  type = object({
    vpc_id            = string
    subnet_ids        = list(string)
    security_group_id = string
  })
  default     = null
  description = <<-EOF
    VPC Configuration for deploying lambdas withing the VPC.
    In such cases specify `subnet_ids` so that ENIs are created for the lambda function in the VPC,
    and a `security_group_id` to define egress rules from lambda functions to other AWS Resources and/or the Internet.
  EOF
}

variable "cloudwatch" {
  type = object({

    logging = object({
      retention_in_days = number
      subscription_filter = object({
        destination_arn = string
        role_arn        = string
      })
      kms_key_id = string
    })

    alarms = optional(object({
      sns_topic_arn               = optional(string)
      duration_threshold          = optional(number)
      failed_invocation_threshold = optional(number)
      log_event_error_threshold   = optional(number)
      log_event_error_pattern     = optional(string)
    }))

    datadog_logging_integrations = optional(object({
      destination_arn = string
      filter_pattern  = optional(string, "")
      role_arn        = string
      distribution    = optional(string, "ByLogStream")
    }))

  })
  description = <<-EOF
    Cloudwatch integration.
    - The "logging" and "datadog_logging_integrations" sections integrates the module with "Centralized Logging" by streaming its
      logs from Cloudwatch to Kinesis Firehose.
    - The "alarms" creates and alarms for provided thresholds on Duration and Errors metrics.
      The alarms will send notifications to the provided SNS Topic.

    Supported metrics thresholds:
    - duration_threshold - duration threshold
    - failed_invocations_threshold - failed invocations threshold
    - log_event_error_threshold - log event error threshold

    If you don't set threshold for an alarm or set it to `null` then that alarm and related metric (if any) won't be created.
  EOF
}

variable "lambda_role_policy_json_enable" { default = false }

variable "lambda_role_policy_json" {
  type        = string
  default     = null
  description = <<-EOF
    Optional IAM Policy describing Lambda permissions to other resources.
    IAM Roles (execution and runtime) will be created by this module internally.
  EOF
}

variable "permissions_boundary_arn" {
  type        = string
  default     = null
  description = <<-EOF
    Permissions boundary to control the maximum permissions related role(s) can have.
  EOF
}
