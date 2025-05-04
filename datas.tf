# data "aws_key_pair" "data_key" {
#   key_name = "ubuntu-key"
# }

# data "aws_subnets" "filtered" {
#   filter {
#     name   = "cidr-block"
#     values = ["10.0.0.0/20"]
#   }
# }

# data "aws_subnet" "data_subnet" {
#     id = tolist(data.aws_subnets.filtered.ids)[0]
# }

# data "aws_security_groups" "data_secur_groups" {
#     filter {
#         name="tag:Name"
#         values = ["my-security-group"]
#     }
# }



