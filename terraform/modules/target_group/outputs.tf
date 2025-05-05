output "id" {
  value = aws_lb_target_group.target_group.id
}

output "detail_infos" {
  value = {
    "arn" = aws_lb_target_group.target_group.arn
    "name" = aws_lb_target_group.target_group.name
    "port" = aws_lb_target_group.target_group.port
    "protocol" =aws_lb_target_group.target_group.protocol
    "vpc_id" = aws_lb_target_group.target_group.vpc_id
    "lb_arns" = aws_lb_target_group.target_group.load_balancer_arns
  }
}

output "object" {
  value = aws_lb_target_group.target_group
}