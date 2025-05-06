db_name = "test_db"
user_name = "admin"
password = "adminh123!"
engine = "mysql"
vpc_id ="vpc-06cc757c52948216f"         # ID của VPC đã có, ví dụ: "vpc-0abc123def456"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
subnet_ids =[
    "subnet-0ddcc0f95d64da0b7",
    "subnet-0be767470fd1ef333"
]