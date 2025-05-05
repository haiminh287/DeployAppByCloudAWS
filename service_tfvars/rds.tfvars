db_name = "test_db"
user_name = "admin"
password = "adminh123!"
engine = "mysql"
vpc_id = "vpc-xxxxxxxx"            # ID của VPC đã có, ví dụ: "vpc-0abc123def456"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

subnet_ids = dung` lenh query truy van (aws) de lay ra