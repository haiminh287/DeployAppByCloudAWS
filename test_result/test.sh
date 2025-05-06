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