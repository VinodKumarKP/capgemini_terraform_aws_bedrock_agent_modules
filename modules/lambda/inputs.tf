variable "function_description" {
  description = "Description of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for Lambda functions"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "function_path" {
  description = "Path of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime of the Lambda function"
  type        = string
  default     = "python3.10"
}

variable "timeout" {
  description = "Timeout of the Lambda function"
  type        = number
  default     = 30
}

variable "pip_requirements" {
  description = "Path of the pip requirements file"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tag for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "layers_arn" {
  description = "ARN of the layers for the Lambda function"
  type        = list(string)
  default     = []
}

variable "memory_size" {
  description = "Memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "prefix" {
  description = "Prefix for the Lambda function"
  type        = string
}