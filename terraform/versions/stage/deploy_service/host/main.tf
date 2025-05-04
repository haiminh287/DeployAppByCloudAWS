module "security_group_for_ec2" {
  source = "../../../../modules/security-group"
  sg_name = var.sg_name
  vpc_id = var.vpc_id
  
  rules = merge(
    {
        "ssh" = {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        },
        "all_icmp_ipv4" = {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        },
        "http" = {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    },
    var.sg_rules
  )
}

module "ec2_host" {
  source = "../../ec2"

  public_key = var.public_key

  instance_name = var.instance_name
  key_name = var.key_name
  subnet_id = var.subnet_id
  security_group_ids = [module.security_group_for_ec2.id]

  user_data = var.user_data
}