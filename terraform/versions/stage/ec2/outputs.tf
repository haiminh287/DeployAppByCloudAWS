output "data" {
  value = {
    "ec2" = {
        "id" = module.ec2_with_kp_clone.id
        "detail_infos" = module.ec2_with_kp_clone.detail_infos
    }
    "key_pair" = {
        "id" = module.key_pair_clone.id
        "detail_infos" = module.key_pair_clone.detail_infos
    }
  }
}