module "db_subnet_group_clone" {
  source = "../../../modules/rds/db-subnet-group"
  name = var.db_subnet_group_name
  subnet_ids = var.subnet_ids
}

module "rds_clone" {
  source = "../../../modules/rds"
  db_name = var.db_name
  username = var.username
  password = var.password
  db_subnet_group_name = module.db_subnet_group_clone.detail_infos["name"]
  vpc_security_group_ids = var.vpc_security_group_ids
  engine = var.engine
  engine_version = var.engine_version
  
}