resource "aws_ecr_repository" "lambda" {
  name = "lambda/${var.app_name}"
}

resource "aws_ecr_lifecycle_policy" "lambda" {
  repository = aws_ecr_repository.lambda.name
  policy     = jsonencode(local.ecr_policy)
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.app_name}-${var.env}"
  image_uri     = "${aws_ecr_repository.lambda.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.lambda.arn
  memory_size   = 512
  timeout       = 900

  ephemeral_storage {
    size = 512
  }

  image_config {
    command = ["handler.main"]
  }

  environment {
    variables = {
      ENV          = var.env
      DATABASE_URL = var.database_url
    }
  }

  depends_on = [
    aws_ecr_repository.lambda
  ]
}
