output "data" {
  value = {
    "security_group" = {
        "id" = module.security_group_for_ec2.id
        "detail_infos" = module.security_group_for_ec2.detail_infos
    },
    "ec2" = module.ec2_host.data["ec2"],
    "key_pair" = module.ec2_host.data["key_pair"]
  }
}