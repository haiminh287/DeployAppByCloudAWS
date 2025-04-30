output "vpc_id" {
  value = aws_vpc.main.id
}


output "subnet_ids" {
  value = {
    for k, mod in module.subnets : k => mod.subnet_id
  }
}