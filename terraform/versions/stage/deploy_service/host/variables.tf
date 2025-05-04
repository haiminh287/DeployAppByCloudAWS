# -------------------------------
# Variables cho module Security Group
# -------------------------------

variable "sg_name" {
  description = "Tên của Security Group cho EC2"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC để gắn SG vào"
  type        = string
}

variable "sg_rules" {
  description = "Các rule bổ sung cho security group"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

# -------------------------------
# Variables cho module EC2
# -------------------------------

variable "public_key" {
  description = "Public key để tạo key pair cho EC2 (nội dung file .pub)"
  type        = string
}

variable "instance_name" {
  description = "Tên gán tag cho EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Tên key pair đã tạo từ trước trên AWS để EC2 sử dụng"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID để khởi tạo EC2"
  type        = string
}

variable "user_data" {
  description = "Script khởi tạo EC2 khi boot (có thể là cloud-init hoặc bash)"
  type        = string
  default     = "" # hoặc null nếu muốn optional
}
