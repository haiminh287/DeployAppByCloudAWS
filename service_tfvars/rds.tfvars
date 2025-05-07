db_name = "cloud"
user_name = "admin"
password = "admin123"
engine = "mysql"
vpc_id = "vpc-097dd4b43cb92643c"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

subnet_ids = ["subnet-08b475a2256435935", "subnet-0a2fcb5a73c9cae2b"]
