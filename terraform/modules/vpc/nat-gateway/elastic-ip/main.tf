resource "aws_eip" "elastic_ip" {
  instance        = var.instance_id         # Gán Elastic IP vào EC2 instance
  network_interface = var.network_interface_id # Gán Elastic IP vào network interface
  address         = var.elastic_ip_address   # Địa chỉ IP công khai
  domain          = var.domain               # Chỉ định domain (vpc hoặc standard)associate_with_private_ip = var.private_ip  # Liên kết với một private IP, nếu có
  public_ipv4_pool = var.public_ipv4_pool   # Pool IP công khai

  tags = merge(
    {
        Name = var.name
        Environment = var.environment
    },
    var.additional_tags
  )
}