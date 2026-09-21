# ============================================================
# WEB SECURITY GROUP
# ============================================================

resource "aws_security_group" "web" {
  name        = "django-helpdesk-poc-web-sg"
  description = "Security group for Nginx web EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-helpdesk-poc-web-sg"
  }
}


# ============================================================
# APPLICATION SECURITY GROUP
# ============================================================

resource "aws_security_group" "app" {
  name        = "django-helpdesk-poc-app-sg"
  description = "Security group for Django application EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Django/Gunicorn from Web EC2"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-helpdesk-poc-app-sg"
  }
}


# ============================================================
# DATABASE SECURITY GROUP
# ============================================================

resource "aws_security_group" "db" {
  name        = "django-helpdesk-poc-db-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from Django application"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-helpdesk-poc-db-sg"
  }
}