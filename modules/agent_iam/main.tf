# IAM Role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "bedrock_agent_lambda_role-${var.prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = "LambdaAssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "lambda_policy" {
  name        = "bedrock_agent_lambda_policy-${var.prefix}"
  description = "Policy for Lambda to access CloudWatch Logs and other necessary services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_iam_role" "agent_role" {
  name = "bedrock_agent_role-${var.prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "bedrock.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = "AmazonBedrockAgentBedrockFoundationModelPolicyProd"
      }
    ]
  })
}

# IAM Policy for Bedrock Agent to invoke Lambda
resource "aws_iam_policy" "bedrock_agent_policy" {
  name        = "bedrock_agent_lambda_invoke_policy-${var.prefix}"
  description = "Policy for Bedrock Agent to invoke Lambda function"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AmazonBedrockAgentBedrockFoundationModelPolicyProd",
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream",
          "bedrock:GetInferenceProfile",
          "bedrock:GetFoundationModel"
        ],
        Resource = [
          "arn:aws:bedrock:*::foundation-model/${var.model_name}",
          "arn:aws:bedrock:*:*:inference-profile/*"
        ]
        Effect   = "Allow"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "bedrock_agent_policy_attachment" {
  role       = aws_iam_role.agent_role.name
  policy_arn = aws_iam_policy.bedrock_agent_policy.arn
}
