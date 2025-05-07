variable "agent_id" {
  description = "ID of the Bedrock agent"
  type        = string
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


variable "functions_json_file" {
  description = "Path to a JSON file containing function details (alternative to functions variable or api_schema)"
  type        = string
  default     = ""
}

variable "api_schema_file" {
  description = "Path to a file containing OpenAPI schema for the action group (alternative to api_schema)"
  type        = string
  default     = ""
}
