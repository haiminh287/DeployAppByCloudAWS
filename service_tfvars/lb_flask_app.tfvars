# terraform.tfvars

public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoAsHn6oKIWlJLa+TtX/fDWMxxgH+bg5RPbsRHd7/7xDKZsSyS4dGuNEhW4tVofAz2u6KMso0RA8lso7JLyjYrX1mgM8I/Z2U5KzGkpzxWDoMgU3dp1prFgjSGLh61PC01Oql8TdElamgATraSQT2grz/mOeXrXLksWQoI1V+CkzmqGZ2s1luN90fQ74zRv31bY/dYpb0Zsp0P/UrrnrhC2XtGh1ee27vRKxI9tVumGGYqFOiNfp3Mm9joPdXglLF6c7O1UhQtLAAsmZNmBy8X2/nfJuxSqT3j3RXGaxjlPz6kture7oQD8AEEUyT7n3ZIyqOKa3uZTBEOMM2AzR75JWrLcENakEay3X3/7H2SN5l0JI8Lgy7d+KojBTsxVW6qF8VgXWBbi++gf3ZF74M7Iqb/K69xzVvC3SPj78vFyllte1mndiva/mcOnDvaD8dldCOUoh87ch4n1hu2Nknxd1bUmUUCW7rQrYPLZTby+8vuEklLbOHyiUYWoicCBDmKpadsWWVCTP3Yq86M8aC8w/CAzbs6OZk1gC+fAWjgACOIXUwCNwc9HE9gTfB0Qp0tUVSu05b3sMrEGBb/qRjOEOOIRX60whNdPwxMuKejzvxpRBCAsE9NXTFSt0nVxJUvH9YAu86LfVld5ytvN6xyZXz7Hn7uPJBprBb5z8qu3Q== GIGABYTE@DESKTOP-LN015NC"        # Hoặc dùng chuỗi public key
user_data = <<EOF
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt các gói cần thiết
apt-get update -y
apt-get install -y python3 python3-pip git python3-venv

# Tạo thư mục và clone dự án
cd /home/ubuntu/
mkdir -p flask_app
cd flask_app
git clone https://github.com/TNieAccStudy/DeliveryService
cd ./DeliveryService/

# Tạo virtual environment
python3 -m venv venv
chown ubuntu:ubuntu ./venv
. venv/bin/activate

# Cài đặt requirements
pip install -r requirements.txt

# Chạy app Flask
cd ./delivery_app/
python3 -m app.index
EOF

host_ports = [8300, 8300]
vpc_id            = "vpc-0366621dc371194d3"              # ID của VPC
subnet_ids        = [
    "subnet-049a504d736ba72f3",
    "subnet-0eff41aeb637bacec"
]

rules = [
  {
    from_port         = 8300
    to_port           = 8300
    listener_protocol = "tcp"                           # Giao thức listener của ALB
    host_protocol     = "tcp"                            # Giao thức mở cho EC2
    cidr_blocks       = ["0.0.0.0/0"]
  }
]
