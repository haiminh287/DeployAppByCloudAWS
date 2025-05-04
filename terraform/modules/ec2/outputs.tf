output "id" {
  value = aws_instance.ec2.id
}

output "detail_infos" {
    value = {
        "public-ip" = aws_instance.ec2.public_ip
        "key-name" = aws_instance.ec2.key_name
        "instance-state" = aws_instance.ec2.instance_state
        "security_groups" = aws_instance.ec2.security_groups
    }
}

output "object" {
  value = aws_instance.ec2
}
