variable "sqs_name" {}
variable "dead_letter_queue_arn" {}
variable "sqs_tags" {}

variable "enable_retry_policy" {
  type    = bool
  default = false  # or false, based on your requirement
}

