# //tam thoi` nhe. 
# # locals {
# #   public_subnets = module.vpc_template.data["subnets"]["public_subnets"]
# # }

# module "alice_rds_1" { // user_id + name_service + service_id ()
#   source = "./terraform/versions/stage/deploy_service/rds"
#   db_name = var.db_name
#   db_subnet_group_name = var.db_subnet_group_name
#   user_name = var.user_name
#   password = var.password
#   sg_name = var.sg_name
#   vpc_id = module.vpc_template.data["vpc"]["id"]
#   subnet_ids = [for subnet in local.public_subnets : subnet.id]
#   sg_rules = {
#     "mysql" = {
#       from_port = "3306"
#       to_port = "3306"
#       protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }


# //  user_id-block_id-service_name - id for service_in_table

# // vd: 1-23 - rds - id in rds_service
# //: 1-23 - host - id.last() +1 in host_service

