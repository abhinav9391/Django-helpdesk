# ============================================================
# RDS SUBNET GROUP
# ============================================================

resource "aws_db_subnet_group" "postgres" {
  name = "django-helpdesk-poc-db-subnet-group"

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]

  tags = {
    Name = "django-helpdesk-poc-db-subnet-group"
  }
}


# ============================================================
# RDS POSTGRESQL
# ONE DATABASE INSTANCE
# ============================================================

resource "aws_db_instance" "postgres" {
  identifier = "django-helpdesk-poc-postgres"

  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 5432

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false

  # Cost-optimized POC: one RDS instance
  multi_az = false

  # Keep backups for 0 days
  backup_retention_period = 0

  # Apply configuration changes immediately
  apply_immediately = true

  # POC environment
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "django-helpdesk-poc-postgres"
    Tier = "database"
  }
}