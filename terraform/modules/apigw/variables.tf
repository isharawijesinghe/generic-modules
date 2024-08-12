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