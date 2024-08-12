variable "dynamodb_name" {
  type = string
}

variable "dynamodb_billing_mode" {
  type = string
  default = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  type = string
}

variable "dynamodb_range_key" {
  type = string
}

variable "dynamodb_attributes" {
  description = "A list of attribute definitions for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
}