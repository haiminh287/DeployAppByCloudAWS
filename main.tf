

module "key_pair" {
  source = "./terraform/modules/key-pair"
}

module "vpc" {
  source = "./terraform/modules/vpc"
  subnets = [
    {
      name   = "private-subnet-1"
    sub_cidr   = "172.16.1.0/24"
    availability_zone     = "us-east-1a"
    map_public_ip_on_launch = false
    },
    {
      name   = "private-subnet-2"
    sub_cidr   = "172.16.2.0/24"
    availability_zone     = "us-east-1b"
    map_public_ip_on_launch = false
    },
     {
      name   = "public-subnet-3"
    sub_cidr   = "172.16.3.0/24"
    availability_zone     = "us-east-1c"
    map_public_ip_on_launch = true
    }
  ]
}

locals {
  instances = [
    {
      name       = "ec2-private-1"
      subnet_key = "private-subnet-1"
      security_group_key = "web_sg"
      user_data = "#!/bin/bash"
    },
    {
      name       = "ec2-private-2"
      subnet_key = "private-subnet-2"
      security_group_key = "web_sg"
      user_data = "#!/bin/bash"
    },
    {
      name       = "ec2-public-3"
      subnet_key = "public-subnet-3"
      security_group_key = "web_sg"
      user_data = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
      EOF
    }
  ]

  ssh = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  http = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  https = {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  icmp = {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  mysql = {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  security_groups = {
    lb_sg = {
      name        = "load-balancer-sg"
      description = "Allow HTTP and HTTPS inbound traffic"
      rules = {
        http  = local.http
        https = local.https
      }
    }

    web_sg = {
      name        = "web-instance-sg"
      description = "Allow SSH, HTTP, HTTPS, MySQL, and ICMP traffic"
      rules = {
        ssh   = local.ssh
        http  = local.http
        https = local.https
        mysql = local.mysql
        icmp  = local.icmp
      }
    }

    rds_sg = {
      name        = "rds-sg"
      description = "Allow MySQL traffic"
      rules = {
        mysql = local.mysql
      }
    }
  }
}


module "security_groups" {
  for_each = local.security_groups
  source = "./terraform/modules/security-group"
  vpc_id = module.vpc.vpc_id
  sg_name       = each.value.name
  rules         = each.value.rules
}

module "rds_mysql" {
  source = "./terraform/modules/rds"
  subnet_ids = [
    module.vpc.subnet_ids["public-subnet-3"],
    module.vpc.subnet_ids["private-subnet-2"]
  ]
  vpc_security_group_ids = [module.security_groups["rds_sg"].security_group_id]
}

resource "local_file" "flask_env" {
  depends_on = [ module.rds_mysql ]
  content = <<-EOT
    DB_HOST=${module.rds_mysql.rds_endpoint}
    DB_USER=
    DB_PASS=admin123!
    DB_NAME=mydb
    DB_PORT=3306
  EOT

  filename = "${path.module}/test_app/.env"
}
module "ec2" {
  for_each = { for inst in local.instances : inst.name => inst }
  source = "./terraform/modules/ec2"
  instance_name = each.value.name
  key_name =  module.key_pair.key_ubuntu_name
  subnet_id = module.vpc.subnet_ids[each.value.subnet_key]
  security_group_ids = [module.security_groups[each.value.security_group_key].security_group_id]
  ngrok_token        = var.ngrok_token
  ngrok_domain       = var.ngrok_domain
  user_data = each.value.user_data
}

