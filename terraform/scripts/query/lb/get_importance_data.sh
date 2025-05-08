#!/bin/bash

LB_ID=""

# Parse tham số
while getopts "i:" opt; do
  case $opt in
    i) LB_ID="$OPTARG" ;;
    \?)
      echo "Usage: $0 -i <vpc_id>"
      exit 1 ;;
  esac
done

# Kiểm tra nếu thiếu VPC_ID
if [[ -z "$LB_ID" ]]; then
  echo "Missing LOAD_BALANCER ID."
  echo "Usage: $0 -i <LB_ID>"
  exit 1
fi

aws elbv2 describe-load-balancers \
  --load-balancer-arns ${LB_ID} \
  --region us-east-1 \
  --query "LoadBalancers[].{
    dnsName: DNSName
  }" \
  --output json