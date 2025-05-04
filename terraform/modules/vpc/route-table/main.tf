resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  # Route tới Internet
    dynamic "route" {
        for_each = var.internet_gateway_id != null ? [1] : []
        content {
            cidr_block = var.internet_gateway_id.cidr_block
            gateway_id = var.internet_gateway_id.gateway_id
        }
    }

  # Route tới NAT Gateway (nếu dùng private subnet)
    dynamic "route" {
        for_each = var.nat_gateway_id != null ? [1] : []
        content {
            cidr_block     = var.nat_gateway_id.cidr_block
            nat_gateway_id = var.nat_gateway_id.nat_gateway_id
        }
    }


  # Route tới Virtual Private Gateway (VPN)

    # dynamic "route" {
    #     for_each = var.vpn_gateway_id != "null" ? [1] : []
    #     content {
    #         cidr_block     = "0.0.0.0/0"
    #         nat_gateway_id = var.vpn_gateway_id
    #     }
    # }

  # Route tới Transit Gateway
#   route {
#     cidr_block         = "172.16.0.0/12"
#     transit_gateway_id = var.transit_gateway_id
#   }

  # Route tới Network Interface
#   route {
#     cidr_block              = "192.168.1.0/24"
#     network_interface_id    = var.network_interface_id
#   }

  # Route tới VPC Peering Connection
#   route {
#     cidr_block                = "192.168.100.0/24"
#     vpc_peering_connection_id = var.vpc_peering_id
#   }

  tags = merge(
    {
      Name        = var.route_table_name
      Environment = var.environment
    },
    var.additional_tags
  )
}