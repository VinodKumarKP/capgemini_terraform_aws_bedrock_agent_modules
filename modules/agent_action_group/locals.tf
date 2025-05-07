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