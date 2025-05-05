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



// dung ko? no phai generate ve` cai root. ma` de chay dc var.<name> thi` variables phai chua' no. 
// ma` chua no neu ko truyen value vao se yeu cau`. ?

// co cach nao ma luc chay rds_alice thi no tu dong bo qua file host_alice ko?. Root k doc toi file host_alice.

// luc destroy thi u` thi` dc tai vi` minh` lay ra r minh` delete cai file di ma`. 
// nhung y vy~ la` cai variable phai ton` tai. san~ thi` minh moi chay dc var. dđó dđundungds ko ?



// Moi lan minh chay là deu su dung template sinh ra.  khong dung thi xoa di. apply or destroy deu sinh file ra tu template

// no bat nhap value , vi no co chua file rds_alice or host_alice. . chu variables root luu all var

//ua the a` neu variabl ko su dung thi` ko can` truyen vao a` :)))
// dung roi . tai nay no dung trong rds_alice no run nen bat truyen vao. a` the a` :)). vy~ lo xa r. ok vay cu chay theo code cu~ di :))
 // sr :)). chot , di ngu ok