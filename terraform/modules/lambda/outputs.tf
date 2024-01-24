output "lambda_function_invoke_arn" {
  value = aws_lambda_function.cde-project-exercisetracker-v2.invoke_arn
  description = "The Invoke ARN of the Lambda Function"
}

output "lambda_function_name" {
  value = aws_lambda_function.cde-project-exercisetracker-v2.function_name
  description = "The name of the Lambda Function"
  }