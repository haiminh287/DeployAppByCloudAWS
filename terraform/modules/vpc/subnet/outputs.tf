output "id" {
  value = aws_subnet.subnet.id
}

output "detail_infos" {
  value = {
    "cidr_block" = aws_subnet.subnet.cidr_block
    "vpc_id" = aws_subnet.subnet.vpc_id
    "public_ip_on_launch" = aws_subnet.subnet.map_public_ip_on_launch
  }
}

output "object" {
  value = aws_subnet.subnet
}