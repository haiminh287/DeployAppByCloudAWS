db_name = "test_db"
user_name = "admin"
password = "adminh123!"
engine = "mysql"
vpc_id ="vpc-001c5180a56baeee9"         # ID của VPC đã có, ví dụ: "vpc-0abc123def456"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
subnet_ids =[
    "subnet-01c751684c8b7472e",
    "subnet-0b6b4148aab84e507"
]