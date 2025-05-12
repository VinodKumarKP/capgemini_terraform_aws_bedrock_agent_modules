output "agent_arn" {
  value = module.bedrock_agent.agent_arn
}

output "lambda_arn" {
  value = module.lambda.function_arn
}

output "lambda_role_name" {
  value = module.agent_iam.lambda_role_name
}

output "lambda_role_arn" {
  value = module.lambda.lambda_role_arn
}