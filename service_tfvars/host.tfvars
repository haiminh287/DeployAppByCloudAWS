# terraform.tfvars

instance_name = "example-host-instance"
key_name      = "your-key-pair-name"
public_key    = file("~/.ssh/id_rsa.pub") # hoặc chuỗi key nếu bạn không dùng file
sg_name       = "example-host-sg"
vpc_id        = "vpc-xxxxxxxx"            # ID của VPC đã có, ví dụ: "vpc-0abc123def456"
subnet_id     = "subnet-xxxxxxxx"         # ID của Subnet, ví dụ: "subnet-0a1b2c3d4e"
user_data     = ""                        # Có thể là chuỗi base64 hoặc để trống nếu không dùng
