output "id" {
  value = aws_db_instance.rds.id
}

output "detail_infos" {
  value = {
    "db_name" = aws_db_instance.rds.db_name
    "username" = aws_db_instance.rds.username
    "password" = aws_db_instance.rds.password
    "engine" = aws_db_instance.rds.engine
    "endpoint" = aws_db_instance.rds.endpoint
    "host" = aws_db_instance.rds.address
    "port" = aws_db_instance.rds.port
    "status" = aws_db_instance.rds.status
  }
}