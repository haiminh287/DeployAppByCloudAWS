module "alice_id-block_id-load_balancer-service_id" {
  # source = "../terraform/versions/stage/deploy_service/alb"
  source               = "./terraform/versions/stage/deploy_service/alb"
  host_sg_name         = "alice_id-block_id-load_balancer-service_id-host_sg"
  key_name             = "alice_id-block_id-load_balancer-service_id-key_name"
  instance_name_prefix = "alice_id-block_id-load_balancer-service_id-lb_instance"
  public_key           = var.public_key
  user_data            = var.user_data

  host_ports = var.host_ports

  lb_name           = "alice_id-block_id-load_balancer-service_id-lb"
  sg_name           = "alice_id-block_id-load_balancer-service_id-sg"
  target_group_name = "alice_id-block_id-load_balancer-service_id-target_group"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  rules = var.rules
}