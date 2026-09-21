# ============================================================
# PUBLIC SUBNET NACL
# ============================================================

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "django-helpdesk-poc-public-nacl"
  }
}

# Allow inbound HTTP
resource "aws_network_acl_rule" "public_in_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Allow inbound HTTPS
resource "aws_network_acl_rule" "public_in_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow inbound ephemeral ports for return traffic
resource "aws_network_acl_rule" "public_in_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Allow outbound HTTP
resource "aws_network_acl_rule" "public_out_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Allow outbound HTTPS
resource "aws_network_acl_rule" "public_out_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow outbound ephemeral ports
resource "aws_network_acl_rule" "public_out_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_association" "public" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public.id
}


# ============================================================
# APPLICATION SUBNET NACL
# ============================================================

resource "aws_network_acl" "app" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "django-helpdesk-poc-app-nacl"
  }
}

# Allow Django/Gunicorn traffic from public subnet
resource "aws_network_acl_rule" "app_in_8000" {
  network_acl_id = aws_network_acl.app.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.1.0/24"
  from_port      = 8000
  to_port        = 8000
}

# Allow ephemeral return traffic from public subnet
resource "aws_network_acl_rule" "app_in_ephemeral" {
  network_acl_id = aws_network_acl.app.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.1.0/24"
  from_port      = 1024
  to_port        = 65535
}

# Allow outbound traffic through NAT
resource "aws_network_acl_rule" "app_out_all" {
  network_acl_id = aws_network_acl.app.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Allow inbound ephemeral return traffic
resource "aws_network_acl_rule" "app_in_return" {
  network_acl_id = aws_network_acl.app.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_association" "app" {
  network_acl_id = aws_network_acl.app.id
  subnet_id      = aws_subnet.app.id
}


# ============================================================
# DATABASE SUBNET NACL
# ============================================================

resource "aws_network_acl" "db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "django-helpdesk-poc-db-nacl"
  }
}

# Allow PostgreSQL from application subnet
resource "aws_network_acl_rule" "db_in_5432" {
  network_acl_id = aws_network_acl.db.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.2.0/24"
  from_port      = 5432
  to_port        = 5432
}

# Allow PostgreSQL return traffic
resource "aws_network_acl_rule" "db_out_ephemeral" {
  network_acl_id = aws_network_acl.db.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.2.0/24"
  from_port      = 1024
  to_port        = 65535
}

# Allow inbound ephemeral traffic for return traffic
resource "aws_network_acl_rule" "db_in_ephemeral" {
  network_acl_id = aws_network_acl.db.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.2.0/24"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_association" "db_a" {
  network_acl_id = aws_network_acl.db.id
  subnet_id      = aws_subnet.db_a.id
}

resource "aws_network_acl_association" "db_b" {
  network_acl_id = aws_network_acl.db.id
  subnet_id      = aws_subnet.db_b.id
}