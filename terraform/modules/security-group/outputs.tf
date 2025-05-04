output "id" {
  value = aws_security_group.security_group.id
}

output "detail_infos" {
  value = {
    "name" = aws_security_group.security_group.name
    "vpc_id" = aws_security_group.security_group.vpc_id
    "ingress" = aws_security_group.security_group.ingress
    "egress" = aws_security_group.security_group.egress
  }
}

output "object" {
  value = aws_security_group.security_group
}