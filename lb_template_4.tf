module "u1-1-lb-4" {
  # source = "../terraform/versions/stage/deploy_service/alb"
  source               = "./terraform/versions/stage/deploy_service/alb"
  host_sg_name         = "u1-1-lb-4-hsg"
  key_name             = "u1-1-lb-4-keyname"
  instance_name_prefix = "u1-1-lb-4-i"
  public_key           = var.public_key
  user_data            = var.user_data

  host_ports = var.host_ports

  lb_name           = "u1-1-lb-4-lb"
  sg_name           = "u1-1-lb-4-sg"
  target_group_name = "u1-1-lb-4-tg"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  rules = var.rules
}