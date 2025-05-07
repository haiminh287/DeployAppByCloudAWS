# Variables dùng chung cho cả 3 modules

variable "public_key" {
  description = "SSH public key để tạo key pair EC2"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..."
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
  default     = "vpc-12345678"
}

variable "subnet_id" {
  description = "ID của subnet cho EC2 host"
  type        = string
  default     = "subnet-12345678"
}

variable "subnet_ids" {
  description = "Danh sách subnet IDs cho RDS hoặc Load Balancer"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}

variable "user_data" {
  description = "Script user_data cho EC2 instances"
  type        = string
  default     = <<-EOT
    #!/bin/bash
    echo "Hello from Terraform" > /var/www/html/index.html
  EOT
}

# Chỉ dùng trong module load balancer

variable "host_ports" {
  description = "Các port của host cần expose"
  type        = list(number)
  default     = [80, 443]
}

variable "rules" {
  description = "Danh sách các rule để mở port trong security group"
  type = list(object({
    from_port         = number
    to_port           = number
    listener_protocol = string
    host_protocol     = string
    cidr_blocks       = list(string)
  }))
  default = [
    {
      from_port         = 80
      to_port           = 80
      listener_protocol = "HTTP"
      host_protocol     = "HTTP"
      cidr_blocks       = ["0.0.0.0/0"]
    },
    {
      from_port         = 443
      to_port           = 443
      listener_protocol = "HTTPS"
      host_protocol     = "HTTPS"
      cidr_blocks       = ["0.0.0.0/0"]
    }
  ]
}

# Chỉ dùng trong module rds

variable "db_name" {
  description = "Tên database"
  type        = string
  default     = "demo_db"
}

variable "user_name" {
  description = "Tên user truy cập database"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Mật khẩu user database"
  type        = string
  default     = "StrongP@ssw0rd123"
}

variable "engine" {
  description = "type database"
  type        = string
  default     = "mysql"
}

variable "sg_rules" {
  description = "Luật security group cho RDS"
  type = map(object({
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "mysql" = {
      from_port   = "3306"
      to_port     = "3306"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
