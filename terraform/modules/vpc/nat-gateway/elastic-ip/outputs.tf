output "id" {
  value = aws_eip.elastic_ip.id
}

output "detail_infos" {
  value = {
    "public_ip" = aws_eip.elastic_ip.public_ip
    "instance_id" = aws_eip.elastic_ip.instance
    "domain" = aws_eip.elastic_ip.domain
  }
}

output "object" {
  value = aws_eip.elastic_ip
}