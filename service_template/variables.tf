# Variables dùng chung cho cả 3 modules
variable "public_key" {
  description = "SSH public key để tạo key pair EC2"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID của subnet cho EC2 host"
  type        = string
}

variable "subnet_ids" {
  description = "Danh sách subnet IDs cho RDS hoặc Load Balancer"
  type        = list(string)
}

variable "user_data" {
  description = "Script user_data cho EC2 instances"
  type        = string
}

# Chỉ dùng trong module load balancer
variable "host_ports" {
  description = "Các port của host cần expose"
  type        = list(number)
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
}

# Chỉ dùng trong module rds
variable "db_name" {
  description = "Tên database"
  type        = string
}
variable "user_name" {
  description = "Tên user truy cập database"
  type        = string
}

variable "password" {
  description = "Mật khẩu user database"
  type        = string
}

variable "engine" {
  description = "type database"
  type = string
  default = "mysql"
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
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }
}