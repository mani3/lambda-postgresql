data "aws_caller_identity" "current" {}

variable "env" {
  type = string
}

variable "app_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "database_url" {
  type = string
}

locals {
  ecr_policy = {
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          countNumber = 5
          countType   = "imageCountMoreThan"
          tagStatus   = "any"
        }
        action = {
          type = "expire"
        }
      }
    ]
  }
}
