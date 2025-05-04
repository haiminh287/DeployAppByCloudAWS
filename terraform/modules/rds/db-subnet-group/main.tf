resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.name
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = var.name
    },
    var.additional_tags
  )
}
