output "id" {
    value = aws_route_table.route_table.id
}

output "detail_infos" {
  value = {
    "vpc_id" = aws_route_table.route_table.vpc_id
    "routes" = aws_route_table.route_table.route
  }
}

output "obj" {
  value = aws_route_table.route_table
}