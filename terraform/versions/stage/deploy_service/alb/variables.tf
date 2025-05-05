# -------------------------------
# Variables cho module Security Group
# -------------------------------

variable "host_sg_name" {
  description = "Tên của Security Group cho EC2"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC để gắn SG vào"
  type        = string
}

# -------------------------------
# Variables cho module EC2
# -------------------------------

variable "public_key" {
  description = "Public key để tạo key pair cho EC2 (nội dung file .pub)"
  type        = string
}

variable "instance_name_prefix" {
  description = "Tên gán tag cho EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Tên key pair đã tạo từ trước trên AWS để EC2 sử dụng"
  type        = string
}

variable "user_data" {
  description = "Script khởi tạo EC2 khi boot (có thể là cloud-init hoặc bash)"
  type        = string
  default     = "" # hoặc null nếu muốn optional
}

variable "host_ports" {
  type = list(number)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "rules" {
  type = list(object({
    from_port = number
    to_port = number
    listener_protocol = string
    host_protocol = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the load balancer"
  type        = list(string)
}
