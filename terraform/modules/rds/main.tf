resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids // Sử dụng subnet IDs được truyền vào từ module cha

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "mydb" // Tên DB instance
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" // Tùy chọn instance class
  username               = "admin"
  password               = "admin123!"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name // Sử dụng subnet group đã tạo ở trên
  vpc_security_group_ids = var.vpc_security_group_ids // Sử dụng security group đã tạo ở trên
  skip_final_snapshot    = true // Bỏ qua snapshot cuối cùng khi xóa DB để tiết kiệm chi phí
  publicly_accessible    = false // công khai
  multi_az               = false // Chỉ sử dụng 1 AZ

  tags = {
    Name = "MyDB"
  }
}




# OUTPUTS
