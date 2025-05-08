#!/bin/bash

RDS_ID=""

# Parse tham số
while getopts "i:" opt; do
  case $opt in
    i) RDS_ID="$OPTARG" ;;
    \?)
      echo "Usage: $0 -i <rds_id>"
      exit 1 ;;
  esac
done

# Kiểm tra nếu thiếu VPC_ID
if [[ -z "$RDS_ID" ]]; then
  echo "Missing RDS ID."
  echo "Usage: $0 -i <RDS_ID>"
  exit 1
fi

  aws rds describe-db-instances \
    --region us-east-1 \
    --query "DBInstances[?DbiResourceId=='$RDS_ID'].DBInstanceStatus" \
    --output json