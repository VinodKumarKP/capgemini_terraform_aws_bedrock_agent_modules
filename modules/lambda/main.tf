module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = var.function_name
  description   = var.function_description
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  create_role = false
  lambda_role = var.role_arn

  source_path = [
    {
      path             = var.function_path
      pip_requirements = var.pip_requirements
    }
  ]

  environment_variables = var.environment_variables

  publish = true

  tags = merge({ name = var.function_name }, var.tags)

  layers = var.layers_arn

}

resource "aws_lambda_permission" "lambda_policy" {
  statement_id  = "AllowExecutionFromBedrock"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "bedrock.amazonaws.com"
}