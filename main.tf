locals {
  availability_zone_default = var.aws_region
}

module "vpc_template" {
  source           = "./terraform/versions/stage/vpc"
  vpc_cidr         = "172.0.0.0/16"
  i_gateway_name   = "test_gateway_01"
  vpc_name         = "test_vpc_01"
  private_rtb_name = "private_route_table_01"
  public_rtb_name  = "public_route_table_01"

  subnets = [
    {
      name                    = "private_subnet_01"
      sub_cidr                = "172.0.0.0/18"
      availability_zone       = "${local.availability_zone_default}a"
      map_public_ip_on_launch = true
      }, {
      name                    = "public_subnet_01"
      sub_cidr                = "172.0.64.0/18"
      availability_zone       = "${local.availability_zone_default}a"
      map_public_ip_on_launch = true
      }, {
      name                    = "private_subnet_02"
      sub_cidr                = "172.0.128.0/18"
      availability_zone       = "${local.availability_zone_default}b"
      map_public_ip_on_launch = true
      }, {
      name                    = "public_subnet_02"
      sub_cidr                = "172.0.192.0/18"
      availability_zone       = "${local.availability_zone_default}b"
      map_public_ip_on_launch = true
    }
  ]
}

locals {
  public_subnets = values(module.vpc_template.data["subnets"]["public_subnets"])
}

module "nat_gateway_test" {
  source           = "./terraform/versions/stage/nat_gateway"
  elastic_ip_name  = "test elastic_ip"
  nat_gateway_name = "test_nat_gateway"
  public_subnet_id = local.public_subnets[0].id
  rtb_privates = [
    module.vpc_template.data["route_tables"]["private_rtb"].id
  ]
}

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

module "host_01" {
  source        = "./terraform/versions/stage/deploy_service/host"
  instance_name = "test_ec2_01"
  key_name      = "test_key_01"
  public_key    = file("./key_gen_01.pub")
  sg_name       = "test_sg_01"
  vpc_id        = module.vpc_template.data["vpc"]["id"]
  subnet_id     = local.public_subnets[0].id
  user_data = <<-EOF
apt-get update -y
apt-get install -y python3 python3-pip git python3-venv

# Tạo thư mục và clone dự án
cd /home/ubuntu/
mkdir -p flask_app
cd flask_app
git clone https://github.com/TNieAccStudy/DeliveryService
cd ./DeliveryService/

# Tạo virtual environment
python3 -m venv venv
chown ubuntu:ubuntu ./venv
. venv/bin/activate

# Cài đặt requirements
pip install -r requirements.txt

# Chạy app Flask
cd ./delivery_app/
python3 -m app.index
EOF

sg_rules = {
  "flask" = {
    from_port = 7300
    to_port = 7300
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

}

# module "host_02" {
#   source        = "./terraform/versions/stage/deploy_service/host"
#   instance_name = "test_ec2_02"
#   key_name      = "test_key_02"
#   public_key    = file("./key_gen_01.pub")
#   sg_name       = "test_sg_02"
#   vpc_id        = module.vpc_template.data["vpc"]["id"]
#   subnet_id     = local.public_subnets[1].id
#   user_data     = ""
# }

# module "lb_deploy" {
#   source               = "./terraform/versions/stage/deploy_service/alb"
#   host_sg_name         = "lb_host_sg"
#   key_name             = "lb_key_pair"
#   instance_name_prefix = "lb_host"
#   public_key           = file("./key_gen_01.pub")
#   user_data            = ""

#   host_ports = [80, 443, 3000]

#   lb_name           = "lb-test-01"
#   sg_name           = "lb_sg_01"
#   target_group_name = "target-group-01"
#   vpc_id            = module.vpc_template.data["vpc"].id
#   subnet_ids        = [for subnet in local.public_subnets : subnet.id]
#   rules = [
#     {
#       from_port = 80
#       to_port = 80
#       listener_protocol = "tcp"
#       host_protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     {
#       from_port = 443
#       to_port = 443
#       listener_protocol = "tcp"
#       host_protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     {
#       from_port = 2700
#       to_port = 3000
#       listener_protocol = "tcp"
#       host_protocol = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
# }