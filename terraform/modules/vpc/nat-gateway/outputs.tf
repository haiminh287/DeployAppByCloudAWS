output "id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "detail_infos" {
  value = {
    "public_ip" = aws_nat_gateway.nat_gateway.public_ip
    "subnet_id" = aws_nat_gateway.nat_gateway.subnet_id
    "association_id" = aws_nat_gateway.nat_gateway.association_id
  }
}

output "object" {
  value = aws_nat_gateway.nat_gateway
}