output "web_public_ip" {
  description = "Public IP address of the web EC2"
  value       = aws_instance.web.public_ip
}

output "web_instance_id" {
  description = "Web EC2 instance ID"
  value       = aws_instance.web.id
}

output "app_instance_id" {
  description = "Application EC2 instance ID"
  value       = aws_instance.app.id
}

output "s3_bucket_name" {
  description = "S3 artifact bucket"
  value       = aws_s3_bucket.artifacts.bucket
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.postgres.port
}