
resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type["micro"]

  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address =  true
# provisioner "remote-exec" {
# inline = [
# "sudo apt-get update",
# "sudo apt-get install -y nginx",
# "sudo service nginx start",
# "curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null",
# "echo 'deb https://ngrok-agent.s3.amazonaws.com buster main' | sudo tee /etc/apt/sources.list.d/ngrok.list",
# "sudo apt update",
# "sudo apt install -y ngrok",
# "ngrok config add-authtoken '${var.ngrok_auth_token}'",
# "ngrok http 80 &"
# ]
# }

# provisioner "remote-exec" {
#   inline = [ 
#     "curl -L https://bit.ly/n8n_install_noai | sh",
#     "sh <(curl -L https://bit.ly/n8n_with_ngrok)
# Token : 2vAQrlh0O9rexvVrdzVDJXGO0q9_7GZN787jA91vfApjZSioC
# Domain : good-sensibly-pug.ngrok-free.app"
#    ]
# }

# provisioner "remote-exec" {
#   inline = [
#     "curl -L https://bit.ly/n8n_install_noai | sh",
#     "curl -L https://bit.ly/n8n_with_ngrok -o install_n8n.sh",
#     "chmod +x install_n8n.sh",
#     "export NGROK_TOKEN=\"${var.ngrok_token}\"",
#     "export NGROK_DOMAIN=\"${var.ngrok_domain}\"",
#     "./install_n8n.sh",
#     "curl -L https://bit.ly/n8n_install_noai | sh"
#   ]
# }
  tags = {
  Name = var.instance_name
  }
  user_data = var.user_data
}
resource "aws_eip" "my_eip" {
  instance = aws_instance.my_ec2.id
}

# # Gán Elastic IP cho instance EC2
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.my_ec2.id
  allocation_id = aws_eip.my_eip.id
}


