resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id                     # VPC mà subnet thuộc về
  cidr_block              = var.subnet_cidr                # CIDR block cho subnet, ví dụ: "10.0.1.0/24"
  availability_zone       = var.availability_zone          # AZ, ví dụ: "us-east-1a"
  map_public_ip_on_launch = var.map_public_ip_on_launch    # true nếu muốn auto assign public IP

  tags = merge(
    {
        Name = var.subnet_name
    },
    var.additional_tags
  )
}