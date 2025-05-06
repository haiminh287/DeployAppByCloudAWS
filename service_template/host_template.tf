module "_2_user_id_2_-_2_block_id_2_-host-_2_service_id_2_" {
  # source = "../terraform/versions/stage/deploy_service/host"
  source = "./terraform/versions/stage/deploy_service/host"
  instance_name = "_2_user_id_2_-_2_block_id_2_-host-_2_service_id_2_-instance"
  key_name = "_2_user_id_2_-_2_block_id_2_-host-_2_service_id_2_-key_name"
  public_key = var.public_key
  sg_name = "_2_user_id_2_-_2_block_id_2_-host-_2_service_id_2_-sg"
  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
  user_data = var.user_data
  sg_rules = var.sg_rules
}