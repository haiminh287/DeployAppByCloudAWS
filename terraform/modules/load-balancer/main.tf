# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_support = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "main-vpc"
#   }
# }

# resource "aws_subnet" "subnet1" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-east-1b"
# }

# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }
# }

# resource "aws_route_table_association" "a1" {
#   subnet_id      = aws_subnet.subnet1.id
#   route_table_id = aws_route_table.rt.id
# }

# resource "aws_route_table_association" "a2" {
#   subnet_id      = aws_subnet.subnet2.id
#   route_table_id = aws_route_table.rt.id
# }

# # Security Group cho EC2 instance
# resource "aws_security_group" "web_sg" {
#   name        = "web-sg"
#   description = "Allow HTTP & MySQL access"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Security Group cho Load Balancer
# resource "aws_security_group" "lb_sg" {
#   name        = "lb-sg"
#   description = "Allow HTTP from internet"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "web1" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.subnet1.id
#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   user_data = file("user_data.sh")

#   tags = {
#     Name = "WebApp1"
#   }
# }

# resource "aws_instance" "web2" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.subnet2.id
#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   user_data = file("user_data.sh")

#   tags = {
#     Name = "WebApp2"
#   }
# }



module "launch-template" {
  source = "./launch-template"
  subnet_id = var.subnet_id_launch_template
  security_groups_ids = var.security_groups_ids_launch_template
}


resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  # subnets            = var.sub
  depends_on = [ aws_internet_gateway.gw ]
}

resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group" "web_tg_8080" {
  name        = "web-tg-8080"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action { // Forward to target group để chuyển tiếp traffic đến target group
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener" "listener_8080" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg_8080.arn
  }
} 

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach1_8080" {
  target_group_arn = aws_lb_target_group.web_tg_8080.arn
  target_id        = aws_instance.web1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "attach2_8080" {
  target_group_arn = aws_lb_target_group.web_tg_8080.arn
  target_id        = aws_instance.web2.id
  port             = 8080
}





output "load_balancer_dns" {
  value = aws_lb.web_lb.dns_name
}

// create hostedzone

resource "aws_route53_zone" "my_zone" {
  name = "example.com"
  
}
