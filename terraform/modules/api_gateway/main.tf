module "lambda_function" {
  source = "./modules/lambda"
}
// Create an HTTP API with API Gateway

// defines a name for the API Gateway and sets its protocol to HTTP
resource "aws_apigatewayv2_api" "cde-project-exercisetracker-v2" {
  name          = "cde-project-exercisetracker-v2"
  protocol_type = "HTTP"
}

/* sets up application stages for the API Gateway - such as "Test", "Staging", and "Production". 
The example configuration defines a single stage, with access logging enabled
*/
resource "aws_apigatewayv2_stage" "v1" {
  api_id = aws_apigatewayv2_api.cde-project-exercisetracker-v2.id

  name        = "v1"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

// configures the API Gateway to use your Lambda function
resource "aws_apigatewayv2_integration" "lambda_function" {
  api_id = aws_apigatewayv2_api.cde-project-exercisetracker-v2.id

  integration_uri    = module.lambda_function.lambda_function_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

/*
maps an HTTP request to a target, in this case your Lambda function. In the example configuration, 
the route_key matches any GET request matching the path /hello. A target matching integrations/<ID> 
maps to a Lambda integration with the given ID
*/
resource "aws_apigatewayv2_route" "root" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

resource "aws_apigatewayv2_route" "hello" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

// defines a log group to store access logs for the aws_apigatewayv2_stage.v1 API Gateway stage
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.v1.name}"

  retention_in_days = 30
}

// gives API Gateway permission to invoke your Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.v1.execution_arn}/*/*"
}



# // Alternative implementation using modules rather than resources
# // https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/blob/master/examples/complete-http/main.tf 
# https://registry.terraform.io/modules/terraform-aws-modules/apigateway-v2/aws/latest

# locals {
#   domain_name = "terraform-aws-modules.modules.tf"
#   subdomain   = "complete-http"
# }

# module "api_gateway" {
#   source = "terraform-aws-modules/apigateway-v2/aws"

#   name          = "TF - timestamp microservice HTTP API Gateway"
#   description   = "TF - timestamp microservice HTTP API Gateway"
#   protocol_type = "HTTP"

#   # Custom domain
#   domain_name                 = "terraform-aws-modules.modules.tf"
#   domain_name_certificate_arn = "arn:aws:acm:us-east-2:909417103453:certificate/b691c1f7-9455-451c-8c35-175e282c31f3"

# # #   cors_configuration = {
# # #     allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
# # #     allow_methods = ["*"]
# # #     allow_origins = ["*"]
# # #   }

# #   # Custom domain
# #   domain_name                 = "terraform-aws-modules.modules.tf"
# #   domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

# #   # Access logs
# #   default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
# #   default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

#   # Routes and integrations
#   integrations = {
#     "GET /" = {
#       lambda_arn               = "arn:aws:lambda:us-east-2:909417103453:function:cde-project-exercisetracker-v2"
#       payload_format_version   = "2.0"
#     #   authorization_type       = "JWT"
#     #   authorizer_id            = aws_apigatewayv2_authorizer.some_authorizer.id
#       throttling_rate_limit    = 80
#       throttling_burst_limit   = 40
#       detailed_metrics_enabled = true
#     }

#     "GET /api" = {
#       lambda_arn               = "arn:aws:lambda:us-east-2:909417103453:function:cde-project-exercisetracker-v2"
#       payload_format_version   = "2.0"
#     #   authorization_type       = "JWT"
#     #   authorizer_id            = aws_apigatewayv2_authorizer.some_authorizer.id
#       throttling_rate_limit    = 80
#       throttling_burst_limit   = 40
#       detailed_metrics_enabled = true
#     }

#     "GET /hello" = {
#       lambda_arn               = "arn:aws:lambda:us-east-2:909417103453:function:cde-project-exercisetracker-v2"
#       payload_format_version   = "2.0"
#     #   authorization_type       = "JWT"
#     #   authorizer_id            = aws_apigatewayv2_authorizer.some_authorizer.id
#       throttling_rate_limit    = 80
#       throttling_burst_limit   = 40
#       detailed_metrics_enabled = true
#     }

#     "$default" = {
#       lambda_arn = "arn:aws:lambda:us-east-2:909417103453:function:cde-project-exercisetracker-v2"
#     }
#   }

# # #   authorizers = {
# # #     "azure" = {
# # #       authorizer_type  = "JWT"
# # #       identity_sources = "$request.header.Authorization"
# # #       name             = "azure-auth"
# # #       audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
# # #       issuer           = "https://sts.windows.net/aaee026e-8f37-410e-8869-72d9154873e4/"
# # #     }
# # #   }

# #   tags = {
# #     Name = "http-apigateway"
# #   }
# }