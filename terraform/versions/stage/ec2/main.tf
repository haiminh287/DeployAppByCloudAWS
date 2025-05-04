module "key_pair_clone" {
    source = "../../../modules/key-pair"
    key_name = var.key_name
    public_key = var.public_key
}

module "ec2_with_kp_clone" {
  source = "../../../modules/ec2"
  ami_id = var.ami_id
  instance_name = var.instance_name
  instance_type = var.instance_type
  key_name = module.key_pair_clone.detail_infos["key_name"]
  subnet_id = var.subnet_id

  user_data = var.user_data
  security_group_ids = var.security_group_ids

  additional_tags = var.additional_tags
}