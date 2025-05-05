module "alice_id-block_id-rds-service_id" {
  # source = "../terraform/versions/stage/deploy_service/rds"
  source = "./terraform/versions/stage/deploy_service/rds"
  db_name = var.db_name
  db_subnet_group_name = "alice_id-block_id-rds-service_id-db_subnet_group"
  user_name = var.user_name
  password = var.password
  sg_name = "alice_id-block_id-rds-service_id-sg"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  sg_rules = var.sg_rules
}