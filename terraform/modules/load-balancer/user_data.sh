#!/bin/bash
# Cập nhật hệ thống
apt update -y
apt upgrade -y

# Cài đặt Apache và PHP
apt install -y apache2 php libapache2-mod-php php-mysql

# Cài đặt MySQL client để kết nối RDS
apt install -y mysql-client

# Enable Apache và khởi động dịch vụ
systemctl enable apache2
systemctl start apache2

# Tạo một file PHP để kiểm tra kết nối đến RDS MySQL
cat <<EOF > /var/www/html/dbtest.php
<?php
\$servername = "REPLACE_WITH_RDS_ENDPOINT";
\$username = "admin";
\$password = "YourSecurePassword123!";
\$database = "mydb"; // Nếu chưa có thì để trống

// Kết nối
\$conn = new mysqli(\$servername, \$username, \$password, \$database);

// Kiểm tra kết nối
if (\$conn->connect_error) {
  die("Kết nối thất bại: " . \$conn->connect_error);
}
echo "Kết nối thành công tới MySQL RDS!";
?>
EOF


#!/bin/bash

# Cập nhật hệ thống và cài gói cơ bản
apt update -y
apt upgrade -y
apt install -y python3 python3-pip python3-dev mysql-client nginx

# Cài đặt virtualenv và Flask + mysqlclient (hoặc pymysql)
pip3 install virtualenv

# Tạo app folder
mkdir -p /home/ubuntu/flaskapp
cd /home/ubuntu/flaskapp

# Tạo môi trường ảo
virtualenv venv
source venv/bin/activate

# Cài đặt Flask và MySQL connector
pip install Flask pymysql gunicorn

# Tạo Flask app
cat <<EOF > app.py
from flask import Flask
import pymysql

app = Flask(__name__)

@app.route("/")
def index():
    try:
        conn = pymysql.connect(
            host="REPLACE_WITH_RDS_ENDPOINT",
            user="admin",
            password="YourSecurePassword123!",
            database="your_database_name", # Nếu chưa có thì để trống
            connect_timeout=5
        )
        return "Kết nối thành công tới MySQL RDS!"
    except Exception as e:
        return f"Lỗi kết nối: {str(e)}"
EOF

# Tạo file wsgi cho gunicorn
cat <<EOF > wsgi.py
from app import app

if __name__ == "__main__":
    app.run()
EOF

# Khởi chạy Flask app bằng Gunicorn trên cổng 80
nohup gunicorn --bind 0.0.0.0:80 wsgi:app &


