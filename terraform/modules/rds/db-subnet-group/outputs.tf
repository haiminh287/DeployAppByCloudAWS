output "id" {
  value = aws_db_subnet_group.db_subnet_group.id
}

output "detail_infos" {
  value = {
    "name" = aws_db_subnet_group.db_subnet_group.name
    "subnet_ids" = var.subnet_ids
  }
}

output "object" {
  value = aws_db_subnet_group.db_subnet_group
}