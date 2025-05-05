output "data" {
  value = {
    "security_group" = {
        "object" = module.security_group_for_rds.object
        "id" = module.security_group_for_rds.id
        "detail_infos" = module.security_group_for_rds.detail_infos
    },
    "rds" = module.rds_deploy.data["rds"],
    "db_subnet_group" = module.rds_deploy.data["db_subnet_group"]
  }
}

