resource "aws_security_group" "security_group" {
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
  egress {
    from_port   = 0                   # Mở tất cả outbound traffic
    to_port     = 0
    protocol    = "-1"                # Cho phép tất cả giao thức
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
        Name = var.sg_name
    },
    var.additional_tags
  )
}