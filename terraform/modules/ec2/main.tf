resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type["micro"]
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true # <-- Auto assign public IP

  user_data = var.user_data

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  monitoring = true # <-- Enable CloudWatch monitoring

  # iam_instance_profile = var.iam_instance_profile # (optional)

  metadata_options {
    http_endpoint            = "enabled"
    http_put_response_hop_limit = 2
    http_tokens              = "required"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      user_data,  # This will make Terraform ignore changes to user_data
    ]
  }

  tags = merge(
    {
      Name = var.instance_name
    },
    var.additional_tags
  )
}