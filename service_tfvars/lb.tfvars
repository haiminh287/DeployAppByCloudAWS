# terraform.tfvars

public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoAsHn6oKIWlJLa+TtX/fDWMxxgH+bg5RPbsRHd7/7xDKZsSyS4dGuNEhW4tVofAz2u6KMso0RA8lso7JLyjYrX1mgM8I/Z2U5KzGkpzxWDoMgU3dp1prFgjSGLh61PC01Oql8TdElamgATraSQT2grz/mOeXrXLksWQoI1V+CkzmqGZ2s1luN90fQ74zRv31bY/dYpb0Zsp0P/UrrnrhC2XtGh1ee27vRKxI9tVumGGYqFOiNfp3Mm9joPdXglLF6c7O1UhQtLAAsmZNmBy8X2/nfJuxSqT3j3RXGaxjlPz6kture7oQD8AEEUyT7n3ZIyqOKa3uZTBEOMM2AzR75JWrLcENakEay3X3/7H2SN5l0JI8Lgy7d+KojBTsxVW6qF8VgXWBbi++gf3ZF74M7Iqb/K69xzVvC3SPj78vFyllte1mndiva/mcOnDvaD8dldCOUoh87ch4n1hu2Nknxd1bUmUUCW7rQrYPLZTby+8vuEklLbOHyiUYWoicCBDmKpadsWWVCTP3Yq86M8aC8w/CAzbs6OZk1gC+fAWjgACOIXUwCNwc9HE9gTfB0Qp0tUVSu05b3sMrEGBb/qRjOEOOIRX60whNdPwxMuKejzvxpRBCAsE9NXTFSt0nVxJUvH9YAu86LfVld5ytvN6xyZXz7Hn7uPJBprBb5z8qu3Q== GIGABYTE@DESKTOP-LN015NC"        # Hoặc dùng chuỗi public key
user_data            = "#!/bin/bash\napt-get update -y && apt-get upgrade -y && apt-get install apache2 -y && systemctl start apache2 && systemctl enable apache2 && echo '<html><body><h1>Apache2 is running!</h1></body></html>' > /var/www/html/index.html"


host_ports = [80, 80]
vpc_id            = "vpc-06cc757c52948216f"              # ID của VPC
subnet_ids        = [
        "subnet-0ddcc0f95d64da0b7",
        "subnet-0be767470fd1ef333",
      ] # Các subnet public để gắn vào ALB

rules = [
  {
    from_port         = 80
    to_port           = 80
    listener_protocol = "tcp"                           # Giao thức listener của ALB
    host_protocol     = "tcp"                            # Giao thức mở cho EC2
    cidr_blocks       = ["0.0.0.0/0"]
  }
]
