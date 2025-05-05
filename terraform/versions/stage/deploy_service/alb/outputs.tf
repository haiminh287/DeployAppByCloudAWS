output "data" {
  value = {
    "hosts" = module.hosts
    "host_security_group" = module.security_group_for_hosts
    "host_key_pair" = module.key_pair_for_host
    "load_balancer" = module.load_balanced.data["load_balancer"]
    "lb_security_group" = module.load_balanced.data["security_group"]
    "lb_target_group" = module.load_balanced.data["target_group"]
    "lb_listeners" = module.load_balanced.data["listeners"]
  }
}