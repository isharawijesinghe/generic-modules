variable "s3_force_destroy" { default = false }

variable "s3_status" {
  type = string
  default = "Enabled"
}

variable "s3_sse_algorithm" {
  type = string
  default = "AES256"
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_block_public_acls" { default = true }

variable "s3_block_public_policy" { default = true }

variable "s3_ignore_public_acls" { default = true }

variable "s3_restrict_public_buckets" { default = true }