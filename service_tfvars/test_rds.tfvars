db_name = "test_db"
user_name = "admin"
password = "adminh123!"
engine = "mysql"
vpc_id ="vpc-0366621dc371194d3"         # ID của VPC đã có, ví dụ: "vpc-0abc123def456"
sg_rules = {
    "mysql" = {
      from_port = "3306"
      to_port = "3306"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
subnet_ids =[
    "subnet-049a504d736ba72f3",
    "subnet-0eff41aeb637bacec"
]