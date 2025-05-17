output "api_schema" {
  value = "${local.use_api_schema}-${local.api_schema_from_file}"
}

output "agent_group_id" {
  value = aws_bedrockagent_agent_action_group.bedrock_agent_action_group.id
}