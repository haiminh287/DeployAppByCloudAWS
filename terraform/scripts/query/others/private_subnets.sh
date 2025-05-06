#!/bin/bash

VPC_ID=""

# Parse tham số
while getopts "i:" opt; do
  case $opt in
    i) VPC_ID="$OPTARG" ;;
    \?)
      echo "Usage: $0 -i <vpc_id>"
      exit 1 ;;
  esac
done

# Kiểm tra nếu thiếu VPC_ID
if [[ -z "$VPC_ID" ]]; then
  echo "Missing VPC ID."
  echo "Usage: $0 -i <vpc_id>"
  exit 1
fi

aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region us-east-1 \
  --query "Subnets[?contains(Tags[?Key=='Name'].Value | [0], 'private')].SubnetId" \
  --output json