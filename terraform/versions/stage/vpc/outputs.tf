output "data" {
  value = {
    "vpc" = {
        "id" = module.vpc_with_full_structure.id
        "detail_infos" = module.vpc_with_full_structure.detail_infos
    },
    "i_gateway" = {
        "id" = module.i_gateway_clone.id
        "detail_infos" = module.i_gateway_clone.detail_infos
    },
    "subnets" = {
        "public_subnets" = local.public_subnets
        "private_subnets" = local.private_subnets
    },
    "route_tables" = {
        "private_rtb" = module.route_table_private
        "public_rtb" = module.route_table_public
    }
  }
}