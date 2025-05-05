module "host_alice" {
  source = "./terraform/versions/stage/deploy_service/host"
  instance_name = "test_ec2_01"
  key_name = "test_key_01"
  public_key = file("./key_gen_01.pub")
  sg_name = "test_sg_01"
  vpc_id = module.vpc_template.data["vpc"]["id"]
  subnet_id = local.public_subnets[0].id
}