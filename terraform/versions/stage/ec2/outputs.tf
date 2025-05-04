output "data" {
  value = {
    "ec2" = {
        "object" = module.ec2_with_kp_clone.object
        "id" = module.ec2_with_kp_clone.id
        "detail_infos" = module.ec2_with_kp_clone.detail_infos
    }
    "key_pair" = {
        "object" = module.key_pair_clone.object
        "id" = module.key_pair_clone.id
        "detail_infos" = module.key_pair_clone.detail_infos
    }
  }
}