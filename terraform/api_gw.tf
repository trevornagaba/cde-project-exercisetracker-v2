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
  api_id = aws_apigatewayv2_api.cde-project-exercisetracker-v2.id

  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

resource "aws_apigatewayv2_route" "hello" {
  api_id = aws_apigatewayv2_api.cde-project-exercisetracker-v2.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

// defines a log group to store access logs for the aws_apigatewayv2_stage.v1 API Gateway stage
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.cde-project-exercisetracker-v2.name}"

  retention_in_days = 30
}

// gives API Gateway permission to invoke your Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.cde-project-exercisetracker-v2.execution_arn}/*/*"
}