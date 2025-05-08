#!/bin/bash

HOST_ID=""

# Parse tham số
while getopts "i:" opt; do
  case $opt in
    i) HOST_ID="$OPTARG" ;;
    \?)
      echo "Usage: $0 -i <host_id>"
      exit 1 ;;
  esac
done

# Kiểm tra nếu thiếu VPC_ID
if [[ -z "$HOST_ID" ]]; then
  echo "Missing HOST ID."
  echo "Usage: $0 -i <host_id>"
  exit 1
fi

aws ec2 start-instances \
    --instance-ids ${HOST_ID} \
    --region us-east-1 \
    --query "StartingInstances[].{status: CurrentState.Name}" \
    --output json
