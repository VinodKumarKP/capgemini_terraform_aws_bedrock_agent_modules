variable "agent_name" {
  type        = string
  description = "Name of the agent"
}

variable "agent_model_name" {
  description = "Name of the model"
  type        = string
  default     = "anthropic.claude-3-5-sonnet-20241022-v2:0"
}

variable "bedrock_agent_role_arn" {
  description = "ARN of the IAM role for the Bedrock agent"
  type        = string
}

variable "agent_instructions" {
  description = "Instructions for the agent"
  type        = string
  default     = "You are a helpful assistant."
}

variable "action_group_name" {
  description = "Name of the action group"
  type        = string
  default     = "data_processing_actions"
}

variable "action_group_executor_lambda_arn" {
  description = "ARN of the Lambda function for the action group executor"
  type        = string
}

variable "agent_action_group_api_schema" {
  description = "OpenAPI schema for the action group"
  type        = string
  default     = ""
}

variable "functions_json_file" {
  description = "Path to a JSON file containing function details (alternative to functions variable or api_schema)"
  type        = string
  default     = ""
}

variable "agent_alias_name" {
  description = "Name of the alias"
  type        = string
  default     = "latest"
}

variable "agent_alias_description" {
  description = "Description of the alias"
  type        = string
  default     = "Latest version of the agent"
}

variable "prepare_agent" {
  description = "Prepare the agent for deployment"
  type        = bool
  default     = true
}