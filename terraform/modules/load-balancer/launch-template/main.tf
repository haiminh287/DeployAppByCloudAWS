resource "aws_launch_template" "ec2_launch_template"{ // Tạo launch template cho EC2 instances để có thể tự động scale
  name_prefix   = "webapp-"
  image_id      = "ami-084568db4383264d4"
  instance_type = "t2.micro"

  lifecycle { // Đảm bảo rằng launch template được tạo trước khi EC2 instances
    create_before_destroy = true // Khi cập nhật launch template, Terraform sẽ tạo một cái mới trước khi xóa cái cũ
  }

  network_interfaces { // Cấu hình network interface cho EC2 instances 
    associate_public_ip_address = true // Gán public IP cho EC2 instances
    delete_on_termination       = true // Xóa network interface khi EC2 instances bị xóa
    device_index                = 0 // Chỉ định network interface đầu tiên
    subnet_id                   = var.subnet_id// Sử dụng subnet1
    security_groups             = var.security_groups_ids 
  }
  
}