variable "public_key" {
  description = "SSH public key để tạo key pair EC2"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..." # Thay bằng public key thực tế
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
    echo "Hello from user_data!" > /var/www/html/index.html
  EOT
}

variable "host_instance_name" {
  description = "Tên instance EC2 cho host"
  type        = string
  default     = "demo-user-block-host-service-instance"
}

variable "host_key_name" {
  description = "Tên key pair cho EC2 host"
  type        = string
  default     = "demo-user-block-host-service-key"
}

variable "host_sg_name" {
  description = "Tên security group cho EC2 host"
  type        = string
  default     = "demo-user-block-host-service-sg"
}

variable "lb_host_sg_name" {
  description = "Tên security group của host do load balancer quản lý"
  type        = string
  default     = "demo-user-block-lb-service-host-sg"
}

variable "lb_key_name" {
  description = "Tên key pair cho instances do load balancer quản lý"
  type        = string
  default     = "demo-user-block-lb-service-key"
}

variable "lb_instance_name_prefix" {
  description = "Prefix tên instance do load balancer tạo"
  type        = string
  default     = "demo-user-block-lb-service-instance"
}

variable "host_ports" {
  description = "Các port của host cần expose"
  type        = list(number)
  default     = [80, 443]
}

variable "lb_name" {
  description = "Tên của Load Balancer"
  type        = string
  default     = "demo-user-block-lb-service"
}

variable "lb_sg_name" {
  description = "Tên security group của Load Balancer"
  type        = string
  default     = "demo-user-block-lb-service-sg"
}

variable "target_group_name" {
  description = "Tên target group của Load Balancer"
  type        = string
  default     = "demo-user-block-lb-service-tg"
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

variable "db_name" {
  description = "Tên database"
  type        = string
  default     = "demo_db"
}

variable "db_subnet_group_name" {
  description = "Tên subnet group cho RDS"
  type        = string
  default     = "demo-user-block-rds-subnet-group"
}

variable "user_name" {
  description = "Tên user truy cập database"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Mật khẩu user database"
  type        = string
  sensitive   = true
  default     = "StrongP@ssw0rd123"
}

variable "rds_sg_name" {
  description = "Tên security group cho RDS"
  type        = string
  default     = "demo-user-block-rds-sg"
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
