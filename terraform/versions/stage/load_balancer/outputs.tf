output "data" {
  value = {
    "load_balancer" = {
        "object" = module.lb.object
        "id" = module.lb.id
        "detail_infos" = module.lb.detail_infos
    },
    "security_group" = {
        "object" = module.security_group.object
        "id" = module.security_group.id
        "detail_infos" = module.security_group.detail_infos
    },
    "target_group" = {
        "object" = module.target_group.object
        "id" = module.target_group.id
        "detail_infos" = module.target_group.detail_infos
    },
    "listeners" = module.listeners
  }
}