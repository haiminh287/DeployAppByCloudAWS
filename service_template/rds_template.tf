module "rds_user" {
  source = "./terraform/versions/stage/deploy_service/rds"
  db_name = var.db_name
  db_subnet_group_name = var.db_subnet_group_name
  user_name = var.user_name
  password = var.password
  sg_name = var.sg_name
  vpc_id = module.vpc_template.data["vpc"]["id"]
  subnet_ids = [for subnet in local.public_subnets : subnet.id]
  sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}