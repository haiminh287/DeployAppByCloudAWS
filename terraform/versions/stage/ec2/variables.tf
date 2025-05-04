variable "ec2_name" {
  type = string
  default="example"
}

variable "instance_name" {
  description = "Tên của EC2 Instance"
  type        = string
}

variable "instance_type" {
  description = "Loại EC2 Instance"
  type        = map(string)
  default     = {
    "micro"= "t2.micro"
  }
}

variable "ami_id" {
  description = "ID của AMI sử dụng"
  type        = string
  default     = "ami-0f9de6e2d2f067fca"  # Thay bằng AMI phù hợp với region của bạn
}

variable "subnet_id" {
  description = "Subnet ID để chạy EC2"
  type        = string
}

variable "security_group_ids" {
  description = "Danh sách Security Group ID"
  type        = list(string)
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "user_data" {
  type = string
  default = ""
}

variable "key_name" {
  description = "Tên SSH Key Pair"
  type        = string
}

variable "public_key" {
  type = string
}