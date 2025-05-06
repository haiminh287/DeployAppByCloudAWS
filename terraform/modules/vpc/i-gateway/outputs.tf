output "id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "detail_infos" {
  value = {
    "vpc_id" = aws_internet_gateway.internet_gateway.vpc_id
  }
}