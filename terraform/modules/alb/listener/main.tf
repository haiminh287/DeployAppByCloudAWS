resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.default_action_type
    target_group_arn = var.target_group_arn
  }

  tags = merge(
    {
      Name = var.name
    },
    var.additional_tags
  )
}
