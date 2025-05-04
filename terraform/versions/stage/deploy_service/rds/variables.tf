# -------------------------------
# Variables cho Security Group
# -------------------------------
variable "sg_name" {
  description = "Tên của Security Group cho RDS"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC nơi tạo security group"
  type        = string
}

variable "sg_rules" {
  description = "Map các rule cho security group"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "mysql" = {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = "0.0.0.0/0"
    }
  }
}

# -------------------------------
# Variables cho RDS
# -------------------------------
variable "db_name" {
  description = "Tên database RDS"
  type        = string
}

variable "user_name" {
  description = "Username cho database RDS"
  type        = string
}

variable "password" {
  description = "Mật khẩu cho database RDS"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Danh sách các subnet ID cho RDS subnet group"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Tên của DB subnet group"
  type        = string
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