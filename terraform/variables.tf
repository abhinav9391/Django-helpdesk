# ============================================================
# DATABASE VARIABLES
# ============================================================

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "helpdesk_db"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "helpdesk_admin"
}

variable "db_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}