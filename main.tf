locals {
  agent_name = "${var.agent_name}-${var.environment}"
}

module "agent_iam" {
  source     = "./modules/agent_iam"
  prefix     = local.agent_name
  model_name = var.agent_model_name
}


module "lambda" {
  source                = "./modules/lambda"
  function_name         = "${var.lambda_function_name}-${local.agent_name}"
  role_arn              = module.agent_iam.lambda_role_arn
  function_path         = var.lambda_function_path
  environment_variables = var.lambda_environment_variables
  function_description  = var.lambda_function_description
  timeout               = var.lambda_timeout
  runtime               = var.lambda_runtime
  pip_requirements      = var.lambda_pip_requirements
  tags = {
    "environment" = var.environment
    "agent_name"  = local.agent_name
  }
  handler = var.lambda_handler
}

module "bedrock_agent" {
  source                           = "./modules/bedrock_agent"
  agent_name                       = local.agent_name
  action_group_executor_lambda_arn = module.lambda.function_arn
  bedrock_agent_role_arn           = module.agent_iam.agent_role_arn
  agent_instructions               = "You are a helpful assistant that processes data and answers questions."
  agent_action_group_api_schema    = var.agent_action_group_api_schema
  functions_json_file              = var.functions_json_file
}
