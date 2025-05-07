# AWS Bedrock Agent Terraform Project

This Terraform project creates an AWS Bedrock Agent with associated resources including agent group, action group, function schema, and Lambda function.

## Architecture

This project provisions the following resources:

- **AWS Bedrock Agent**: An AI agent powered by the Claude model
- **Agent Group**: A group that can contain one or more agents
- **Action Group**: Defines the capabilities of the agent through an API schema
- **Lambda Function**: Implements the API functions that the agent can invoke
- **IAM Roles and Policies**: For secure access between services

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate permissions
- Access to AWS Bedrock service and Claude model

## Usage

1. Clone this repository
2. Update the `terraform.tfvars` file with your desired configuration
3. Initialize the Terraform project:
   ```bash
   terraform init
   ```
4. Review the planned changes:
   ```bash
   terraform plan
   ```
5. Apply the changes:
   ```bash
   terraform apply
   ```

## Modules

### bedrock_agent

Creates the Bedrock agent, action group, and associated resources.

### bedrock_agent_group

Creates a Bedrock agent group and adds agents to it.

### iam

Creates the necessary IAM roles and policies for the agent and Lambda function.

### lambda_function

Creates the Lambda function using the terraform-aws-lambda module.


## Clean Up

To remove all resources created by this project:

```bash
terraform destroy
```

## License

This project is licensed under the MIT License.
