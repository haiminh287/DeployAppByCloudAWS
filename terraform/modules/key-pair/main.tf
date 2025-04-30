resource "aws_key_pair" "my_ubuntu_key" {
  key_name   = "ubuntu-key"
  public_key = file("${path.module}/ubuntu-key.pub")
}