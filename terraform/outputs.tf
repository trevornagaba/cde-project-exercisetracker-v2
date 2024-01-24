# output "instance_ip_addr" {
#   value = aws_instance.server.private_ip
# }

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.cde-project-exercisetracker-v2.invoke_url
}