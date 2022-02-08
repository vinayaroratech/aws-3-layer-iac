resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%*"
}

resource "aws_db_instance" "database" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "12.7"
  instance_class         = "db.t3.micro"
  identifier             = "${var.project}-db-instance"
  name                   = "${var.project}${terraform.workspace}"
  username               = "${var.project}${terraform.workspace}"
  password               = random_password.password.result
  db_subnet_group_name   = var.vpc.database_subnet_group
  vpc_security_group_ids = [var.sg.db_sg]
  skip_final_snapshot    = true
}
