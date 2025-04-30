resource "aws_security_group" "main_security_group" {
  name        = var.sg_name
  description =  "Security Group with Ingress and Egress rules"
  vpc_id      = var.vpc_id

  # Ingress rules
  dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Outbound rules (Mặc định AWS mở tất cả)
  dynamic "egress" {
    for_each = var.rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  # Outbound rules (Mặc định AWS mở tất cả)
  egress {
    from_port   = 0                   # Mở tất cả outbound traffic
    to_port     = 0
    protocol    = "-1"                # Cho phép tất cả giao thức
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}







# resource "aws_security_group" "my_seg_01" {
#   name        = "my-security-group"
#   description = "Allow SSH and HTTP inbound traffic"
#   vpc_id      = var.vpc_id  # Thay bằng VPC của bạn

#   # Inbound rules
#   ingress {
#     from_port   = 22                  # SSH
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]       # Mở cho tất cả IP (⚠️ Không an toàn)
#   }
#  ingress {
#     from_port   = 80                  # HTTP
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]       # Mở cho tất cả IP (⚠️ Không an toàn)
#   }
#   # Outbound rules (Mặc định AWS mở tất cả)
#   egress {
#     from_port   = 0                   # Mở tất cả outbound traffic
#     to_port     = 0
#     protocol    = "-1"                # Cho phép tất cả giao thức
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#   from_port   = -1
#   to_port     = -1
#   protocol    = "icmp"
#   cidr_blocks = ["0.0.0.0/0"]
# }

  
#   ingress {
#     from_port   = 3306 // MySQL
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] // Allow traffic from the RDS security group
#   }

#   tags = {
#     Name = "my-security-group"
#   }
# }

