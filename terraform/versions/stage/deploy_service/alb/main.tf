module "security_group_for_hosts" {
  source = "../../../../modules/security-group"
  sg_name = var.host_sg_name
  vpc_id = var.vpc_id
  
  rules = merge(
    {
        "ssh" = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        },
        "all_icmp_ipv4" = {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        },
        "http" = {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    },
    {
      for rule in var.rules : rule.to_port => {
        from_port = rule.to_port
        to_port = rule.to_port
        protocol = rule.host_protocol
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  )
}

module "key_pair_for_host" {
    source = "../../../../modules/key-pair"
    key_name = var.key_name
    public_key = var.public_key
}

resource "random_integer" "pick_index" {
  min = 0
  max = length(var.subnet_ids) - 1
}

locals {
  subnet_random = var.subnet_ids[random_integer.pick_index.result]
}

module "hosts" {
  count = length(var.host_ports)
  source = "../../../../modules/ec2"
  instance_name = "${var.instance_name_prefix}_${count.index}"
  key_name = module.key_pair_for_host.detail_infos["key_name"]
  subnet_id = local.subnet_random

  user_data = var.user_data
  security_group_ids = [module.security_group_for_hosts.id]

  additional_tags = {}
}

module "load_balanced" {
  source = "../../load_balancer"
  lb_name = var.lb_name
  sg_name = var.sg_name
  target_group_name = var.target_group_name
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  instances = [for idx, host in module.hosts : {
    id = host.id
    port = var.host_ports[idx]
  }]

  listener_rules = [
    for rule in var.rules : {
      from_port = rule.from_port
      to_port = rule.to_port
      protocol = rule.listener_protocol
      cidr_blocks = rule.cidr_blocks
    }
  ]
}
