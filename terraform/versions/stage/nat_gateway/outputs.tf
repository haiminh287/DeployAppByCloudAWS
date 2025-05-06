output "data" {
  value = {
    "nat_gateway" = {
        "id" = module.nat_gateway_default.id
        "detail_infos" = module.nat_gateway_default.detail_infos
    },
    "elastic_ip" = {
        "id" = module.elastic_ip_clone.id
        "detail_infos" = module.elastic_ip_clone.detail_infos
    }
  }
}