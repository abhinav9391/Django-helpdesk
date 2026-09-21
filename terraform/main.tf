# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "django-helpdesk-poc-vpc"
  }
}


# ============================================================
# PUBLIC SUBNET
# ============================================================

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "django-helpdesk-poc-public-subnet"
  }
}


# ============================================================
# PRIVATE APPLICATION SUBNET
# ============================================================

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "django-helpdesk-poc-app-subnet"
  }
}


# ============================================================
# PRIVATE DATABASE SUBNET A
# ============================================================

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "django-helpdesk-poc-db-subnet-a"
  }
}


# ============================================================
# PRIVATE DATABASE SUBNET B
# ============================================================

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "django-helpdesk-poc-db-subnet-b"
  }
}


# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "django-helpdesk-poc-igw"
  }
}


# ============================================================
# ELASTIC IP FOR NAT GATEWAY
# ============================================================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "django-helpdesk-poc-nat-eip"
  }
}


# ============================================================
# NAT GATEWAY
# ============================================================

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "django-helpdesk-poc-nat"
  }
}


# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "django-helpdesk-poc-public-rt"
  }
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# ============================================================
# PRIVATE APPLICATION ROUTE TABLE
# ============================================================

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "django-helpdesk-poc-app-rt"
  }
}


resource "aws_route_table_association" "app" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.app.id
}


# ============================================================
# PRIVATE DATABASE ROUTE TABLE
# ============================================================

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "django-helpdesk-poc-db-rt"
  }
}


resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.db.id
}


resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.db.id
}