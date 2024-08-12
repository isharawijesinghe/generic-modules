variable "environment" {}
variable "name" {}
variable "service_name" {default     = "" }
variable "tags" { type = map(string) }
variable "retention_in_days" { default = 90 }
variable "kms_key_id" { default     = null }
variable "subscription_filter" {
  type = object({
    role_arn        = string
    destination_arn = string
  })
  default     = null
  description = "Use to automatically attach a subscription filter to a Log Group."
}
variable "name_override" {
  default     = false
  type        = bool
}
