variable "agent_name" {
  type        = string
  description = "Name of the agent"
}

variable "lambda_function_path" {
  type        = string
  description = "Path to the lambda function"
}

variable "lambda_function_description" {
  description = "Description of the Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime of the Lambda function"
  type        = string
  default     = "python3.10"
}

variable "lambda_timeout" {
  description = "Timeout of the Lambda function"
  type        = number
  default     = 30
}

variable "lambda_pip_requirements" {
  description = "Path of the pip requirements file"
  type        = bool
  default     = false
}

variable "lambda_environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "lambda_handler" {
  description = "Handler of the Lambda function"
  type        = string
}

variable "agent_model_name" {
  description = "Name of the model"
  type        = string
  default     = "anthropic.claude-3-5-sonnet-20241022-v2:0"
}

variable "environment" {
  description = "Environment of the agent"
  type        = string
  default     = "dev"
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

variable "lambda_layers_arn" {
  description = "ARN of the Lambda layer"
  type        = list(string)
  default     = []
}

variable "lambda_memory_size" {
  description = "Memory size of the Lambda function"
  type        = number
  default     = 128
}


variable "agent_instructions" {
  description = "Instructions for the agent"
  type        = string
}