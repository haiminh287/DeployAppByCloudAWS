resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = var.eip_id         # Gán Elastic IP cho NAT Gateway
  subnet_id     = var.subnet_id          # ID của subnet nơi NAT Gateway được tạo
  tags = {
    Name = var.name
  }
}