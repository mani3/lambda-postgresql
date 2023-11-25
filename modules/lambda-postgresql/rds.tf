resource "aws_db_instance" "default" {
  allocated_storage = 10
  db_name           = "dvdrental"
  engine            = "postgres"
  engine_version    = "13.13"
  instance_class    = "db.t3.micro"
  username          = "postgres"
  # password               = ""
  parameter_group_name   = "default.postgres13"
  skip_final_snapshot    = true
  publicly_accessible    = true
  apply_immediately      = true
  vpc_security_group_ids = var.security_group_ids

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}
