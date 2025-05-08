# terraform.tfvars

public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoAsHn6oKIWlJLa+TtX/fDWMxxgH+bg5RPbsRHd7/7xDKZsSyS4dGuNEhW4tVofAz2u6KMso0RA8lso7JLyjYrX1mgM8I/Z2U5KzGkpzxWDoMgU3dp1prFgjSGLh61PC01Oql8TdElamgATraSQT2grz/mOeXrXLksWQoI1V+CkzmqGZ2s1luN90fQ74zRv31bY/dYpb0Zsp0P/UrrnrhC2XtGh1ee27vRKxI9tVumGGYqFOiNfp3Mm9joPdXglLF6c7O1UhQtLAAsmZNmBy8X2/nfJuxSqT3j3RXGaxjlPz6kture7oQD8AEEUyT7n3ZIyqOKa3uZTBEOMM2AzR75JWrLcENakEay3X3/7H2SN5l0JI8Lgy7d+KojBTsxVW6qF8VgXWBbi++gf3ZF74M7Iqb/K69xzVvC3SPj78vFyllte1mndiva/mcOnDvaD8dldCOUoh87ch4n1hu2Nknxd1bUmUUCW7rQrYPLZTby+8vuEklLbOHyiUYWoicCBDmKpadsWWVCTP3Yq86M8aC8w/CAzbs6OZk1gC+fAWjgACOIXUwCNwc9HE9gTfB0Qp0tUVSu05b3sMrEGBb/qRjOEOOIRX60whNdPwxMuKejzvxpRBCAsE9NXTFSt0nVxJUvH9YAu86LfVld5ytvN6xyZXz7Hn7uPJBprBb5z8qu3Q== GIGABYTE@DESKTOP-LN015NC"
vpc_id = "vpc-097dd4b43cb92643c"
subnet_id = "subnet-08b475a2256435935"

user_data = <<EOF
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
USER_HOME=/home/ubuntu

# Update và cài gói cần thiết
apt-get update -y
apt-get install -y python3 python3-pip git python3-venv

# Tạo thư mục và clone nếu chưa có
mkdir -p $USER_HOME/flask_app
cd $USER_HOME/flask_app

if [ ! -d "DeliveryService" ]; then
    git clone https://github.com/TNieAccStudy/DeliveryService
fi

cd DeliveryService

# Tạo virtual environment
python3 -m venv venv
chown ubuntu:ubuntu ./venv
. venv/bin/activate

# Cài đặt requirements
pip install -r requirements.txt

# Chạy app (background + ghi log)
cd delivery_app
nohup python3 -m app.index > $USER_HOME/flask_app/flask.log 2>&1 &
EOF

sg_rules = {
    "flask" = {
      from_port = "7300"
      to_port = "7300"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}   