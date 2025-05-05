# locals {
#   availability_zone_default = var.aws_region
# }

# module "vpc_template" {
#   source           = "./terraform/versions/stage/vpc"
#   vpc_cidr         = "172.0.0.0/16"
#   i_gateway_name   = "test_gateway_01"
#   vpc_name         = "test_vpc_01"
#   private_rtb_name = "private_route_table_01"
#   public_rtb_name  = "public_route_table_01"

#   subnets = [
#     {
#       name                    = "private_subnet_01"
#       sub_cidr                = "172.0.0.0/18"
#       availability_zone       = "${local.availability_zone_default}a"
#       map_public_ip_on_launch = true
#       }, {
#       name                    = "public_subnet_01"
#       sub_cidr                = "172.0.64.0/18"
#       availability_zone       = "${local.availability_zone_default}a"
#       map_public_ip_on_launch = true
#       }, {
#       name                    = "private_subnet_02"
#       sub_cidr                = "172.0.128.0/18"
#       availability_zone       = "${local.availability_zone_default}b"
#       map_public_ip_on_launch = true
#       }, {
#       name                    = "public_subnet_02"
#       sub_cidr                = "172.0.192.0/18"
#       availability_zone       = "${local.availability_zone_default}b"
#       map_public_ip_on_launch = true
#     }
#   ]
# }

# locals {
#   public_subnets = values(module.vpc_template.data["subnets"]["public_subnets"])
# }

# module "nat_gateway_test" {
#   source           = "./terraform/versions/stage/nat_gateway"
#   elastic_ip_name  = "test elastic_ip"
#   nat_gateway_name = "test_nat_gateway"
#   public_subnet_id = local.public_subnets[0].id
#   rtb_privates = [
#     module.vpc_template.data["route_tables"]["private_rtb"].id
#   ]
# }

# module "security_group_test_rds" {
#   source  = "./terraform/modules/security-group"
#   sg_name = "sg_01"
#   vpc_id  = module.vpc_template.data["vpc"]["id"]

#   rules = {
#     "ssh" = {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     "all_icmp_ipv4" = {
#       from_port   = -1
#       to_port     = -1
#       protocol    = "icmp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     "mysql" = {
#       from_port   = 3306
#       to_port     = 3306
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# module "rds_test" {
#   source                 = "./terraform/versions/stage/rds" //  change k 
#   db_name                = "mydb"
#   username               = "admin"
#   password               = "admin0pass"
#   subnet_ids             = [for subnet in local.public_subnets : subnet.id]
#   db_subnet_group_name   = "subnet_group_test_01"
#   vpc_security_group_ids = [module.security_group_test_rds.id]
# }

# module "rds_user" {
#   source               = "./terraform/versions/stage/deploy_service/rds"
#   db_name              = "test_mysql_01"
#   db_subnet_group_name = "rds_subnet_group_01"
#   user_name            = "admin"
#   password             = "admin0pass"
#   sg_name              = "rds_security_01"
#   vpc_id               = module.vpc_template.data["vpc"]["id"]
#   subnet_ids           = [for subnet in local.public_subnets : subnet.id]
#   sg_rules = {
#     "mysql" = {
#       from_port   = "3306"
#       to_port     = "3306"
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# module "host_01" {
#   source        = "./terraform/versions/stage/deploy_service/host"
#   instance_name = "test_ec2_01"
#   key_name      = "test_key_01"
#   public_key    = file("./key_gen_01.pub")
#   sg_name       = "test_sg_01"
#   vpc_id        = module.vpc_template.data["vpc"]["id"]
#   subnet_id     = local.public_subnets[0].id
# }

# // test
# module "host_01" {
#   source        = "./terraform/versions/stage/deploy_service/host"
#   instance_name = var.instance_name 
#   key_name      = "test_key_01"
#   public_key    = file("./key_gen_01.pub")
#   sg_name       = "test_sg_01"
#   vpc_id        = module.vpc_template.data["vpc"]["id"]
#   subnet_id     = local.public_subnets[0].id
# }


// luc minh chay la cmt het may cai cũ dđi rôồi . 


// cai nay` thieu variable nen phai them vao. ma` thi chay neu minh chya cua rds thi` cai nay` dau co
  //vay thi` khi chay no phai truyen vao dko. nen no bi dinh' o? cho~ nay. la` vars cua rds & host != nhau. Dau. luc ma minh chayj 