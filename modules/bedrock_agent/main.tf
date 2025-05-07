resource "aws_bedrockagent_agent" "bedrock_agent" {
  agent_name              = var.agent_name
  agent_resource_role_arn = var.bedrock_agent_role_arn
  foundation_model        = var.agent_model_name # Use your preferred model
  instruction             = var.agent_instructions

  # This depends on aws_bedrock_agent_action_group resource below
  skip_resource_in_use_check = true
  prepare_agent = var.prepare_agent
}


module "agent_action_group" {
  source                           = "../agent_action_group"
  action_group_executor_lambda_arn = var.action_group_executor_lambda_arn
  agent_id                         = aws_bedrockagent_agent.bedrock_agent.id
  api_schema_file                  = var.agent_action_group_api_schema
  functions_json_file              = var.functions_json_file
}


# Bedrock Agent Alias
resource "aws_bedrockagent_agent_alias" "bedrock_agent_alias" {
  agent_id         = aws_bedrockagent_agent.bedrock_agent.id
  agent_alias_name = var.agent_alias_name
  description      = var.agent_alias_description
}

