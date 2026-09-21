# ============================================================
# EC2 IAM ROLE
# ============================================================

resource "aws_iam_role" "ec2" {
  name = "django-helpdesk-poc-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "django-helpdesk-poc-ec2-role"
  }
}


# ============================================================
# SSM PERMISSIONS
# ============================================================

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# ============================================================
# CLOUDWATCH PERMISSIONS
# ============================================================

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# ============================================================
# S3 ACCESS
# ============================================================

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# ============================================================
# EC2 INSTANCE PROFILE
# ============================================================

resource "aws_iam_instance_profile" "ec2" {
  name = "django-helpdesk-poc-ec2-profile"
  role = aws_iam_role.ec2.name

  tags = {
    Name = "django-helpdesk-poc-ec2-profile"
  }
}