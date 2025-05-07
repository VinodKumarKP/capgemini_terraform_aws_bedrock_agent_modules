variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "app"
}

variable "model_name" {
  description = "Name of the model"
  type        = string
  default     = "anthropic.claude-3-5-sonnet-20240620-v1:0"
}