## Defines specific components of the infrastructure
## Physical, virtual or logical resource like ec2, heroku app etc
## Resource type and name
## Whenever you create a new configuration, you need to terra init to download and install the resource
# module "lambda_function_container_image" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name                 = "cde-project-exercisetracker-v2"
#   description                   = "A simple exercise tracker app"
#   create_package                = false
#   image_uri                     = var.image_uri
#   package_type                  = "Image"
#   architectures                 = ["x86_64"] # ["arm64"]

# }


resource "aws_lambda_function" "cde-project-exercisetracker-v2" {
  function_name = "cde-project-exercisetracker-v2"
  package_type  = "Image"
  image_uri     = var.image_uri

  # runtime = "nodejs12.x"
  # handler = "hello.handler"

  # source_code_hash = data.archive_file.lambda_cde-project-exercisetracker-v2.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "cde-project-exercisetracker-v2" {
  name = "/aws/lambda/${aws_lambda_function.cde-project-exercisetracker-v2.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
