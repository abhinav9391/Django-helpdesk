provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project     = "django-helpdesk"
      Environment = "poc"
      ManagedBy   = "terraform"
    }
  }
}