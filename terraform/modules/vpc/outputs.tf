output "id" {
  value = aws_vpc.vpc.id
}

output "detail_infos" {
    value = {
        "cidr_block" = aws_vpc.vpc.cidr_block
        "main_rtb_id" = aws_vpc.vpc.main_route_table_id
    }
}