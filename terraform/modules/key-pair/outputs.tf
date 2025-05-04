output "id" {
  value = aws_key_pair.key_pair.key_pair_id
}

output "detail_infos" {
    value = {
        "key_name" = aws_key_pair.key_pair.key_name
        "public_key" = aws_key_pair.key_pair.public_key
        "key_type" = aws_key_pair.key_pair.key_type
    }
}

output "object" {
  value = aws_key_pair.key_pair
}