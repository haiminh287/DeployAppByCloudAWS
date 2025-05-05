module "alice_id-block_id-host-service_id" {
  # source = "../terraform/versions/stage/deploy_service/host"
  source = "./terraform/versions/stage/deploy_service/host"
  instance_name = "alice_id-block_id-host-service_id-instance"
  key_name = "alice_id-block_id-host-service_id-key_name"
  public_key = var.public_key
  sg_name = "alice_id-block_id-host-service_id-sg"
  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
  user_data = var.user_data
}