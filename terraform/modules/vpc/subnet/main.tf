resource "aws_subnet" "this" { // Create a subnet in the VPC 
  vpc_id = var.vpc_id
  cidr_block = var.sub_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch // This is to enable public IP on the instances launched in this subnet

    tags = {
        Name =var.name
    }
}