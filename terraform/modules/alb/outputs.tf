output "id" {
  value = aws_lb.lb.id
}

output "detail_infos" {
  value = {
    "arn" = aws_lb.lb.arn
    "name" = aws_lb.lb.name
    "vpc_id" = aws_lb.lb.vpc_id
  }
}

output "object" {
  value = aws_lb.lb
}