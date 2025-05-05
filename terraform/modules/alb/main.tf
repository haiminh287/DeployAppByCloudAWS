resource "aws_lb" "lb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  tags = merge(
    {
      Name = var.name
    },
    var.additional_tags
  )
}
