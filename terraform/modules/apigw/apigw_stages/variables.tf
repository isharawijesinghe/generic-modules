variable "apigw_deployment_id" { type = string }
variable "apigw_rest_api_id" { type = string }
variable "environment" { type = string }
variable "name" { type = string }
variable "tags" { type = map(any) }
variable "cloudwatch_log_group_arn" {}
variable "stage" {
  type = object({
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
  })
}