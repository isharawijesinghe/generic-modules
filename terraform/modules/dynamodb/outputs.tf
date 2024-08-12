output "dynamo_db_table_name" {
  value = aws_dynamodb_table.dynamo_db.name
}

output "dynamo_db_table_arn" {
  value = aws_dynamodb_table.dynamo_db.arn
}

