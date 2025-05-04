module "security_group_for_rds" {
  source = "../../../../modules/security-group"
  sg_name = var.sg_name
  vpc_id = var.vpc_id
  
  rules = merge(
    {
        "ssh" = {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    },
    var.sg_rules
  )
}

module "rds_deploy" {
  source = "../../rds"
  db_name = var.db_name
  username = var.user_name
  password = var.password
  subnet_ids = var.subnet_ids
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [module.security_group_for_rds.id]

  engine = var.engine
  engine_version = var.engine_version
}