locals {
  retry_policy = var.enable_retry_policy ? jsonencode({
    deadLetterTargetArn = var.dead_letter_queue_arn
    maxReceiveCount     = 5
  }) : null
}


resource "aws_sqs_queue" "sqs_queue" {
  name                      = var.sqs_name
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
  redrive_policy = local.retry_policy
  tags = var.sqs_tags
}