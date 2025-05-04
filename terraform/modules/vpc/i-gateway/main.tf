resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = var.name
      Environment = var.environment
    },
    var.additional_tags
  )
}
