output "data" {
  value = {
    "nat_gateway" = {
        "object" = module.nat_gateway_default.object
        "id" = module.nat_gateway_default.id
        "detail_infos" = module.nat_gateway_default.detail_infos
    },
    "elastic_ip" = {
        "object" = module.elastic_ip_clone.object
        "id" = module.elastic_ip_clone.id
        "detail_infos" = module.elastic_ip_clone.detail_infos
    }
  }
}