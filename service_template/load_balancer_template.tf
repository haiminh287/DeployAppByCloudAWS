module "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_" {
  # source = "../terraform/versions/stage/deploy_service/alb"
  source               = "./terraform/versions/stage/deploy_service/alb"
  host_sg_name         = "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_-host_sg"
  key_name             = "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_-key_name"
  instance_name_prefix = "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_-lb_instance"
  public_key           = var.public_key
  user_data            = var.user_data

  host_ports = var.host_ports

  lb_name           = "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_-lb"
  sg_name           = "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_-sg"
  target_group_name = "_2_user_id_2_-_2_block_id_2_-load_balancer-_2_service_id_2_-target_group"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  rules = var.rules
}