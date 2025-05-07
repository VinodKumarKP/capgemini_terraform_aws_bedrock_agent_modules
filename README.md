# AWS Bedrock Agent Terraform Module

This Terraform module helps deploy and manage AWS Bedrock Agents with associated Lambda functions for implementing custom action groups. The module abstracts the complexity of creating the necessary IAM roles, permissions, and resource connections required for a fully functional Bedrock Agent.

## TODO
- [] Add the architecture diagram

## Architecture

The module creates the following resources:
- AWS Bedrock Agent with customizable instructions
- AWS Lambda function for handling agent action groups
- IAM roles and policies for secure interactions between services
- Agent action groups with support for either OpenAPI schema or function definitions
- Agent aliases for versioning

## Prerequisites

- Terraform v1.0+
- AWS CLI configured with appropriate permissions
- AWS account with access to Bedrock and Lambda services
- Appropriate AWS region where Bedrock is available (e.g., `us-east-1`, `us-west-2`)
- Access to Bedrock Foundation Models (may require request approval in AWS console)
- Python 3.10+ for Lambda function development

## Usage

### Basic Usage

```hcl
module "bedrock_agent" {
  source = "path/to/module"

  agent_name               = "my-data-processing-agent"
  environment              = "dev" 
  lambda_function_path     = "./lambda_code"
  lambda_function_name     = "data-processor"
  lambda_function_description = "Process data for my Bedrock agent"
  lambda_handler           = "lambda_function.lambda_handler"
  
  # Optional: Define environment variables for Lambda
  lambda_environment_variables = {
    LOG_LEVEL = "INFO"
  }
}
```

### Complete Example with Backend Configuration

```hcl
# provider.tf
provider "aws" {
  region = "us-east-1"  # Region where Bedrock is available
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "bedrock-agent/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

# main.tf
module "bedrock_agent" {
  source = "path/to/module"

  agent_name               = "customer-support-agent"
  environment              = "prod" 
  lambda_function_path     = "./lambda_code"
  lambda_function_name     = "customer-support-handler"
  lambda_function_description = "Process customer support requests via Bedrock agent"
  lambda_handler           = "lambda_function.lambda_handler"
  
  # Using Claude 3.5 Sonnet
  agent_model_name         = "anthropic.claude-3-5-sonnet-20240620-v1:0"
  
  # Custom agent instructions
  agent_instructions       = "You are a helpful customer support assistant that can process returns, check order status, and handle common support questions."
  
  lambda_environment_variables = {
    LOG_LEVEL = "INFO",
    ORDER_API_ENDPOINT = "https://api.example.com/orders",
    RETURNS_API_ENDPOINT = "https://api.example.com/returns"
  }
  
  # Using pip requirements file
  lambda_pip_requirements = true
}

# outputs.tf
output "agent_arn" {
  value = module.bedrock_agent.agent_arn
  description = "ARN of the Bedrock Agent"
}
```

### Using OpenAPI Schema

```hcl
module "bedrock_agent" {
  source = "path/to/module"

  agent_name                   = "openapi-agent"
  environment                  = "dev"
  lambda_function_path         = "./lambda_code"
  lambda_function_name         = "api-handler"
  lambda_function_description  = "Handle API requests for Bedrock agent"
  lambda_handler               = "lambda_function.lambda_handler"
  agent_action_group_api_schema = file("./openapi_schema.json")
}
```

### Using Functions JSON File

```hcl
module "bedrock_agent" {
  source = "path/to/module"

  agent_name                = "functions-agent"
  environment               = "dev"
  lambda_function_path      = "./lambda_code"
  lambda_function_name      = "functions-handler"
  lambda_function_description = "Handle function calls for Bedrock agent"
  lambda_handler            = "lambda_function.lambda_handler"
  functions_json_file       = "./functions.json"
}
```

## Module Structure

```
.
├── inputs.tf                  # Main module input variables
├── main.tf                    # Main module configuration
├── outputs.tf                 # Main module outputs
├── modules/
│   ├── agent_action_group/    # Submodule for configuring action groups
│   ├── agent_iam/             # Submodule for IAM roles and policies
│   ├── bedrock_agent/         # Submodule for Bedrock Agent configuration
│   └── lambda/                # Submodule for Lambda function deployment
```

## Input Variables

### Main Module Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| agent_name | Name of the agent | `string` | n/a | yes |
| lambda_function_path | Path to the lambda function code directory | `string` | n/a | yes |
| lambda_function_description | Description of the Lambda function | `string` | n/a | yes |
| lambda_function_name | Name of the Lambda function | `string` | n/a | yes |
| lambda_runtime | Runtime of the Lambda function | `string` | `"python3.10"` | no |
| lambda_timeout | Timeout of the Lambda function in seconds | `number` | `30` | no |
| lambda_pip_requirements | Whether to include pip requirements.txt | `bool` | `false` | no |
| lambda_environment_variables | Environment variables for the Lambda function | `map(string)` | `{}` | no |
| lambda_handler | Handler of the Lambda function | `string` | n/a | yes |
| agent_model_name | Name of the Bedrock model | `string` | `"anthropic.claude-3-5-sonnet-20240620-v1:0"` | no |
| environment | Environment name (dev, prod, etc.) | `string` | `"dev"` | no |
| agent_action_group_api_schema | OpenAPI schema for the action group | `string` | `""` | no |
| functions_json_file | Path to JSON file containing function details | `string` | `""` | no |

## Function JSON Format

When using `functions_json_file`, the JSON should be structured as follows:

```json
[
  {
    "name": "functionName",
    "description": "Description of what the function does",
    "parameters": [
      {
        "name": "parameterName",
        "type": "string",
        "description": "What this parameter is used for",
        "required": true
      }
    ]
  }
]
```

### Example Function JSON

Here's a concrete example for a weather checking function:

```json
[
  {
    "name": "getWeatherForecast",
    "description": "Gets the weather forecast for a specific location",
    "parameters": [
      {
        "name": "location",
        "type": "string",
        "description": "The city and state, e.g., 'Seattle, WA'",
        "required": true
      },
      {
        "name": "days",
        "type": "integer",
        "description": "Number of days for the forecast",
        "required": false
      }
    ]
  },
  {
    "name": "getAirQualityIndex",
    "description": "Gets the air quality index for a specific location",
    "parameters": [
      {
        "name": "location",
        "type": "string",
        "description": "The city and state, e.g., 'Portland, OR'",
        "required": true
      }
    ]
  }
]
```

## Lambda Function Handler

Your Lambda function should implement a handler that can process requests from the Bedrock Agent. Here's a simple example:

```python
import json
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Handler for Bedrock Agent action group invocations.
    
    Args:
        event: The Lambda event data containing Bedrock Agent request details
        context: Lambda context runtime information
        
    Returns:
        Response dictionary for Bedrock Agent
    """
    # Log incoming event for debugging
    logger.info(f"Received event: {json.dumps(event)}")
    
    # Parse the request from Bedrock Agent
    action_group = event.get('actionGroup')
    api_path = event.get('apiPath')
    request_body = event.get('requestBody', {})
    parameters = {}
    
    # Extract parameters if available
    if request_body and 'properties' in request_body:
        parameters = request_body.get('properties', {})
    
    logger.info(f"Processing action_group: {action_group}, api_path: {api_path}")
    logger.info(f"Parameters: {parameters}")
    
    # Route to appropriate function based on action group and API path
    result = "Default response"
    
    # Example routing logic
    if action_group == "data_processing_actions":
        if api_path == "/getWeatherForecast":
            location = parameters.get('location', 'Unknown')
            days = parameters.get('days', 1)
            result = f"Weather forecast for {location} for the next {days} days: Sunny, 75°F"
        elif api_path == "/getAirQualityIndex":
            location = parameters.get('location', 'Unknown')
            result = f"Air Quality Index for {location}: Good (45)"
    
    # Construct the response
    response = {
        "messageVersion": "1.0",
        "response": {
            "actionGroup": action_group,
            "apiPath": api_path,
            "httpMethod": event.get('httpMethod', 'POST'),
            "httpStatusCode": 200,
            "responseBody": {
                "application/json": {
                    "body": {
                        "result": result
                    }
                }
            }
        }
    }
    
    logger.info(f"Returning response: {json.dumps(response)}")
    return response
```

### Lambda Function Directory Structure

Organize your Lambda code directory like this:

```
lambda_code/
├── lambda_function.py   # Main handler file
├── requirements.txt     # Python dependencies
├── utils/
│   ├── __init__.py
│   └── helpers.py       # Helper functions
└── README.md            # Documentation
```

### Example requirements.txt

```
requests==2.31.0
boto3==1.34.0
python-dateutil==2.8.2
```

## Outputs

| Name | Description |
|------|-------------|
| agent_arn | ARN of the created Bedrock Agent |

## Security Considerations

This module creates IAM roles with the minimum necessary permissions for the services to interact. The Lambda function is given permissions to write logs to CloudWatch, and the Bedrock Agent is given permissions to invoke the Lambda function.

### Extending IAM Permissions

If your Lambda function needs additional AWS permissions (e.g., to access DynamoDB, S3, etc.), you can extend the IAM policy. Create a file in your project (e.g., `custom_iam.tf`):

```hcl
# Add additional permissions to the Lambda role
resource "aws_iam_policy" "lambda_additional_permissions" {
  name        = "lambda-additional-permissions"
  description = "Additional permissions for Bedrock Agent Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = "arn:aws:dynamodb:*:*:table/my-table",
        Effect   = "Allow"
      },
      {
        Action = [
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::my-bucket/*",
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_additional_permissions" {
  role       = module.bedrock_agent.lambda_role_name
  policy_arn = aws_iam_policy.lambda_additional_permissions.arn
}
```

## License
Capgemini