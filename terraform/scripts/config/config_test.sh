terraform/scripts/setup/aws_conf_setup.sh

terraform fmt // định dạng lại file    
terraform destroy -target=module.rds_mysql.aws_db_instance.mysql 
ssh-keygen -t rsa -b 4096 -f ubuntu-key


chạy ssh-keygen -y -f <pemfile> check
icacls "ubuntu-key" /inheritance:r

icacls "C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\ubuntu-key" /inheritance:r


icacls "C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\ubuntu-key" /grant:r "%USERNAME%:R"



// Flask
// sudo apt-get update
// sudo apt install python3 python3-pip nginx git
// cd /home/ubuntu
// mkdir flask_app
// cd flask_app
// git clone ""
// sudo apt install python3-venv
// python3 -m venv venv
// source venv/bin/activate
// pip install -r requirements.txt
// python app.py
// pip3 install gunicorn
// gunicorn -w 3 -b 0.0.0.0:5000 app:app
// sudo nano /etc/conf.d/flask_app.conf
// server {
#     listen 80;
    //    server_name <your_domain_or_ip_public>;

//}

