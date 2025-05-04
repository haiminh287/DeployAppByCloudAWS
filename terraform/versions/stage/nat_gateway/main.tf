module "elastic_ip_clone" {
  source = "../../../modules/vpc/nat-gateway/elastic-ip"
  name = var.elastic_ip_name
  additional_tags = {}
}

module "nat_gateway_default" {
  source = "../../../modules/vpc/nat-gateway"
  name = var.nat_gateway_name
  eip_id = module.elastic_ip_clone.id
  subnet_id = var.public_subnet_id
}

module "route_rtb_privates" {
  source = "../../../modules/actions/route"
  nat_gateway_id = module.nat_gateway_default.id
  for_each = {for idx, rtb in var.rtb_privates : idx => rtb }
  private_route_table_id = each.value
}