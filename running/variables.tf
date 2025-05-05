variable "aws_region" {
  type = string
}

# variable "db_name" {
#   description = "Tên cơ sở dữ liệu sẽ được tạo"
#   type        = string
# }

# variable "db_subnet_group_name" {
#   description = "Tên subnet group cho RDS"
#   type        = string
# }

# variable "user_name" {
#   description = "Tên người dùng admin cho RDS"
#   type        = string
# }

# variable "password" {
#   description = "Mật khẩu cho người dùng admin"
#   type        = string
#   sensitive   = true
# }

# variable "sg_name" {
#   description = "Tên security group cho RDS"
#   type        = string
# }

# # variable "vpc_id" {
# #   description = "ID của VPC nơi RDS sẽ được tạo"
# #   type        = string
# # }

# # variable "subnet_ids" {
# #   description = "Danh sách các subnet ID để gán cho subnet group"
# #   type        = list(string)
# # }

# # variable "sg_rules" {
# #   description = "Luật security group cho RDS"
# #   type = map(object({
# #     from_port   = string
# #     to_port     = string
# #     protocol    = string
# #     cidr_blocks = list(string)
# #   }))
# # }
