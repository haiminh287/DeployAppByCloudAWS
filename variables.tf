variable "aws_region" {
  type = string
}

variable "db_name" {
  description = "Tên cơ sở dữ liệu sẽ được tạo"
  type        = string
  default = "value"
}

variable "db_subnet_group_name" {
  description = "Tên subnet group cho RDS"
  type        = string
  default = "value"
}

variable "user_name" {
  description = "Tên người dùng admin cho RDS"
  type        = string
  default = "value"
}

variable "password" {
  description = "Mật khẩu cho người dùng admin"
  type        = string
  sensitive   = true
  default = "value"
}

variable "sg_name" {
  description = "Tên security group cho RDS"
  type        = string
  default = "value"
}

variable "vpc_id" {
  description = "ID của VPC nơi RDS sẽ được tạo"
  type        = string
  default = "value"
}

variable "subnet_ids" {
  description = "Danh sách các subnet ID để gán cho subnet group"
  type        = list(string)
  default = []
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
    "name" = {
      from_port = "3306"
      to_port   = "3306"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}


variable "instance_name" {
  type = string
  default = ""
}

// luu all var cua 2 service day nhe gio vy~ chay ma` ko dung` bat ki cai nao` xem cai instance_name co bat buoc ko .