db_name = "test_new"
user_name = "admin"
password = "admin"
engine = "mysql"
db_subnet_group_name = "rds_subnet_group_02"
sg_name = "rds_security_02"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

subnet_ids = dung` lenh query truy van (aws) de lay ra