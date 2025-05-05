module "target_group" {
  source = "../../../modules/target_group"
  name = var.target_group_name
  vpc_id = var.vpc_id
}

locals {
  combined_rules = {
    for idx, port in distinct(concat(
      [{ 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }],
      var.listener_rules
    )) : port.from_port => port
  }
}

module "security_group" {
  source = "../../../modules/security-group"
  vpc_id = var.vpc_id
  sg_name = var.sg_name
  rules = local.combined_rules
}

module "lb" {
  source = "../../../modules/alb"
  name = var.lb_name
  security_groups = [module.security_group.id]
  subnet_ids = var.subnet_ids
}

module "listeners" {
  for_each = local.combined_rules

  source = "../../../modules/alb/listener"
  name = "listener_${each.key}"
  target_group_arn = module.target_group.detail_infos["arn"]
  load_balancer_arn = module.lb.detail_infos["arn"]

  port = each.value.from_port
}

module "attachments" {
  for_each = {for idx, instance in var.instances : idx => instance}

  source = "../../../modules/actions/attachment"
  target_group_arn = module.target_group.detail_infos["arn"]
  target_id = each.value.id
  port = each.value.port
}