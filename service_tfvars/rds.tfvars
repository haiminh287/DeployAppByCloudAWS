db_name = "deliverydb"
user_name = "admin"
password = "admin0pass"
engine = "mysql"
vpc_id = "vpc-0a81ff6eb355fafb1"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

subnet_ids = ["subnet-03bada74ff50867f9", "subnet-08410f1df0251e95b"]
