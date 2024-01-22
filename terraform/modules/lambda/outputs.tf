output "lambda_function_invoke_arn" {
  value = module.lambda_function_container_image.lambda_function_invoke_arn
  description = "The Invoke ARN of the Lambda Function"
}

output "lambda_function_name" {
  value = module.lambda_function_container_image.lambda_function_name
  description = "The name of the Lambda Function"
  }