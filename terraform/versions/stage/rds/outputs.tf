output "data" {
  value = {
    "db_subnet_group" = {
        "id" = module.db_subnet_group_clone.id
        "detail_infos" = module.db_subnet_group_clone.detail_infos
    },
    "rds" = {
        "id" = module.rds_clone.id
        "detail_infos" = module.rds_clone.detail_infos
    }
  }
}
