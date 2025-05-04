variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = "default.mysql8.0"
}

variable "db_subnet_group_name" {
  type = string
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip snapshot on delete"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "additional_tags" {
  type = map(string)
  default = {}
}
