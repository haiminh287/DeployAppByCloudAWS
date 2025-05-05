module "_2_user_id_2_-_2_block_id_2_-rds-_2_service_id_2_" {
  source = "../terraform/versions/stage/deploy_service/rds"
  # source = "./terraform/versions/stage/deploy_service/rds"
  db_name = var.db_name
  db_subnet_group_name = "_2_user_id_2_-_2_block_id_2_-rds-_2_service_id_2_-db_subnet_group"
  user_name = var.user_name
  password = var.password
  engine = var.engine
  sg_name = "_2_user_id_2_-_2_block_id_2_-rds-_2_service_id_2_-sg"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  sg_rules = var.sg_rules
}