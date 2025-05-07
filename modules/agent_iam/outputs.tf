output "agent_role_arn" {
  description = "ARN of the IAM role for Bedrock agents"
  value       = aws_iam_role.agent_role.arn
}

output "agent_role_name" {
  description = "Name of the IAM role for Bedrock agents"
  value       = aws_iam_role.agent_role.name
}

output "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda functions"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  description = "Name of the IAM role for Lambda functions"
  value       = aws_iam_role.lambda_role.name
}