variable "ec2_name" {
  type = string
  default="example"
}


variable "instance_name" {
  description = "Tên của EC2 Instance"
  type        = string
  default     = "my-ec2-instance"
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
  default     = "ami-084568db4383264d4"  # Thay bằng AMI phù hợp với region của bạn
}

variable "key_name" {
  description = "Tên SSH Key Pair"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID để chạy EC2"
  type        = string
}

variable "security_group_ids" {
  description = "Danh sách Security Group ID"
  type        = list(string)
}

variable "ngrok_token" {
  description = "Token Ngrok"
  type        = string
}

variable "ngrok_domain" {
  description = "Token Ngrok"
  type        = string
}
variable "user_data" {
  type = string
  description = "value of user data"
}