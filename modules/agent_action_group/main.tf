
locals {
  # Parse functions from JSON file if provided
  functions_from_file = var.functions_json_file != "" ? jsondecode(file(var.functions_json_file)) : []

  # Load API schema from file if provided
  api_schema_from_file = var.api_schema_file != "" ? file(var.api_schema_file) : ""

  # Determine which API schema to use (direct or from file)
  api_schema = local.api_schema_from_file != "" ? local.api_schema_from_file : ""

  # Determine approach: API schema or function details
  use_api_schema = local.api_schema != ""
  use_functions  = length(local.functions_from_file) > 0
}


# Bedrock Agent Action Group
resource "aws_bedrockagent_agent_action_group" "my_action_group" {
  agent_id          = var.agent_id
  action_group_name = var.action_group_name
  # Use API schema if provided
  action_group_executor {
    lambda = var.action_group_executor_lambda_arn
  }
  action_group_state = "ENABLED"

  dynamic "api_schema" {
    for_each = local.use_api_schema ? [1] : []
    content {
      payload = local.api_schema
    }
  }

  # Use function details if provided (and API schema is not provided)
  dynamic "function_schema" {
    for_each = (local.use_functions && !local.use_api_schema) ? [1] : []

    content {
      member_functions {
        dynamic "functions" {
          for_each = local.functions_from_file
          content {
            name        = functions.value.name
            description = functions.value.description
            dynamic "parameters" {
              for_each = functions.value.parameters
              content {
                map_block_key = parameters.value.name
                type          = parameters.value.type
                description   = parameters.value.description
                required      = parameters.value.required
              }
            }
          }
        }
      }
    }
  }

  agent_version              = "DRAFT"
  skip_resource_in_use_check = true
}