output "data" {
  value = {
    "load_balancer" = {
        "id" = module.lb.id
        "detail_infos" = module.lb.detail_infos
    },
    "security_group" = {
        "id" = module.security_group.id
        "detail_infos" = module.security_group.detail_infos
    },
    "target_group" = {
        "id" = module.target_group.id
        "detail_infos" = module.target_group.detail_infos
    },
    "listeners" = module.listeners
  }
}