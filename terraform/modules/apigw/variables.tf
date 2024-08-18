variable "environment" {}

variable "api_name" {}

variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "apigw_body" {
  description = "OpenAPI specification for API Gateway"
  type        = any
}

variable "endpoint_type" {
  type    = string
  default = "REGIONAL"
}

variable "cloudwatch" {
  type = object({
    kms_key_arn = string
    logging = object({
      retention_in_days = number
      subscription_filter = object({
        role_arn        = string
        destination_arn = string
      })
    })
  })
}

variable "stages" {
  type = list(object({
    name                 = string
    xray_tracing_enabled = optional(bool, false)
    access_log_enabled   = optional(bool, false)
    method_settings = object({
      metrics_enabled      = optional(bool, false)
      logging_level        = optional(string, "INFO")
      caching_enabled      = optional(bool, false)
      cache_data_encrypted = optional(bool, false)
    })
    throttle_enabled = optional(bool, false)
    throttle_settings = optional(object({
      burst_limit = optional(number, null)
      rate_limit  = optional(number, null)
    }))
    vpc_link_name         = optional(string, null)
    vpc_links_target_arns = optional(list(string), null)
    wafv2_web_acl_arn     = optional(string, null)
  }))
}