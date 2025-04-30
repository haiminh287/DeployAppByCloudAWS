variable "sg_name" {
  description = "Tên của Security Group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID mà Security Group sẽ được tạo"
  type        = string
}


variable "rules" {
  description = "Map các quy tắc ingress và egress"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
