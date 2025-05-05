module "vpc_with_full_structure" {
  source = "../../../modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

}

module "i_gateway_clone" {
  source = "../../../modules/vpc/i-gateway"
  name = var.i_gateway_name
  vpc_id = module.vpc_with_full_structure.id
}

module "subnets_clone" {
  for_each = {for subnet in var.subnets : subnet.name => subnet}

  source = "../../../modules/vpc/subnet"
  vpc_id = module.vpc_with_full_structure.id
  subnet_name = each.value.name
  subnet_cidr = each.value.sub_cidr
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  additional_tags = {}
}

module "route_table_public" {
  source = "../../../modules/vpc/route-table"
  vpc_id = module.vpc_with_full_structure.id
  internet_gateway_id = {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.i_gateway_clone.id
  }
  route_table_name = var.public_rtb_name

  additional_tags = {}
}

module "route_table_private" {
  source = "../../../modules/vpc/route-table"
  vpc_id = module.vpc_with_full_structure.id
  route_table_name = var.private_rtb_name

  additional_tags = {}
}

locals {
  public_subnets = {
    for k, v in module.subnets_clone :
      k => v.object if can(regex("(?i)public", v.object.tags_all["Name"]))
  }

  private_subnets = {
    for k, v in module.subnets_clone :
      k => v.object if can(regex("(?i)private", v.object.tags_all["Name"]))
  }
}

resource "aws_route_table_association" "asc_private_subnet" {
  for_each = {for k, v in local.private_subnets
      : k => v }

  subnet_id      = each.value.id
  route_table_id = module.route_table_private.id
}

resource "aws_route_table_association" "asc_public_subnet" {
  for_each = {for k, v in local.public_subnets
      : k => v }

  subnet_id      = each.value.id
  route_table_id = module.route_table_public.id
}

// aws rds describe-db-subnet-groups --db-subnet-group-name subnet_group_test_01 --query "DBSubnetGroups[*].VpcId"