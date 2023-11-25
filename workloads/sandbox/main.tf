locals {
  env = "sandbox"
  app = "lambda-postgresql"
}

data "aws_parameter_store_parameter" "database_url" {
  name = "/lambda/postgresql/database_url"
}

module "lambda-postgresql" {
  source             = "../../modules/lambda-postgresql"
  env                = local.env
  app_name           = local.app
  security_group_ids = ["sg-cea7e8a9"]
  database_url       = data.aws_parameter_store_parameter.database_url.value
}
