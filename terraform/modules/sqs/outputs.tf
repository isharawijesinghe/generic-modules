output "sqs_queue_url" {
  value = aws_sqs_queue.sqs_queue.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.sqs_queue.arn
}