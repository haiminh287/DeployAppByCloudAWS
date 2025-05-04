resource "aws_db_instance" "rds" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  db_subnet_group_name = var.db_subnet_group_name
  publicly_accessible  = var.publicly_accessible
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = merge(
    {
        Name = var.db_name
    },
    var.additional_tags
  )
}
