db_name = "test_db"
user_name = "admin"
password = "adminh123!"
engine = "mysql"
vpc_id ="vpc-087598ba4f1b026f7"         # ID của VPC đã có, ví dụ: "vpc-0abc123def456"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
subnet_ids =[
    "subnet-017ccc8e82d8d19dc",
    "subnet-03e5a69a683e1679b"
]