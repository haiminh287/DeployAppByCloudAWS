output "id" {
  value = aws_lb_listener.lb_listener.id
}

output "detail_infos" {
  value = {
    "arn" = aws_lb_listener.lb_listener.arn
    "lb_arn" = aws_lb_listener.lb_listener.load_balancer_arn
    "port" = aws_lb_listener.lb_listener.port
    "protocol" = aws_lb_listener.lb_listener.protocol
    "default_action" = aws_lb_listener.lb_listener.default_action
  }
}