# bash auto_generate_template/generate_apply_template.sh -f service_template/load_balancer_template.tf -o ./test_load_balancer_template_01.tf -u alice -b block_01 -s service_01 -v service_tfvars/test_load_balancer.tfvars


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