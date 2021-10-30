##################################################################
#Outputs EC2 and DynamoDB table ID
##################################################################

output "ec2_id" {
  value       = aws_instance.test_ec2.id
  description = "The EC2 instance ID"
}

output "dynamodb_table_id" {
  value       = aws_dynamodb_table.basic-dynamodb-table.id
  description = "The DynamoDb table ID"
}