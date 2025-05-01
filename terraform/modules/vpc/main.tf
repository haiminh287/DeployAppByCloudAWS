resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
enable_dns_support   = true
  enable_dns_hostnames = true
    tags = {
        Name = "my-vpc"
    }
}
module "subnets" {
  vpc_id   = aws_vpc.main.id
  source   = "./subnet"
  for_each = { for subnet in var.subnets : subnet.name => subnet }
  name     = each.value.name
  sub_cidr      = each.value.sub_cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch   = each.value.map_public_ip_on_launch
}


resource "aws_internet_gateway" "my_igw_01" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "my-igw_01"
    }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw_01.id
  }
}
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = var.vpc_cidr
#     gateway_id = "local" # mặc định là local
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }


# resource "aws_route_table_association" "rta_private_subnet_1" {
#   subnet_id      = module.subnets["private-subnet-1"].subnet_id
#   route_table_id = aws_route_table.private_route_table.id
# }

# resource "aws_route_table_association" "rta_private_subnet_2" {
#   subnet_id      = module.subnets["private-subnet-2"].subnet_id
#   route_table_id = aws_route_table.private_route_table.id
# }

resource "aws_route_table_association" "my_rta_for_subnet_01" {
  subnet_id      = module.subnets["public-subnet-3"].subnet_id
  route_table_id = aws_route_table.my_route_table.id
}

# resource "aws_nat_gateway" "main_nat_gateway" {
#   allocation_id = aws_eip.main_nat_gateway.id
#   subnet_id     = module.subnets["public-subnet-3"].subnet_id
#   depends_on = [aws_internet_gateway.my_igw_01] // Đảm bảo NAT Gateway được tạo sau Internet Gateway
#   tags = {
#     Name = "main_nat_gateway"
#   }
  
# }

# resource "aws_eip" "main_nat_gateway" {
#   depends_on = [aws_internet_gateway.my_igw_01] // Đảm bảo EIP được tạo sau Internet Gateway
#   tags = {
#     Name = "main_nat_gateway_eip"
#   }
# }