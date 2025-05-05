# terraform.tfvars

public_key           = file("~/.ssh/id_rsa.pub")         # Hoặc dùng chuỗi public key
user_data            = ""                                # Hoặc có thể là script cloud-init dạng base64

host_ports = [80, 443]
vpc_id            = "vpc-0123456789abcdef0"              # ID của VPC
subnet_ids        = ["subnet-aaaa1111", "subnet-bbbb2222"] # Các subnet public để gắn vào ALB

rules = [
  {
    from_port         = 80
    to_port           = 80
    listener_protocol = "HTTP"                           # Giao thức listener của ALB
    host_protocol     = "tcp"                            # Giao thức mở cho EC2
    cidr_blocks       = ["0.0.0.0/0"]
  },
  {
    from_port         = 443
    to_port           = 443
    listener_protocol = "HTTPS"
    host_protocol     = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
]
