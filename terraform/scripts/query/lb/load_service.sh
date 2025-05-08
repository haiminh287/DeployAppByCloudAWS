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

TARGET_GROUPS=$(aws elbv2 describe-target-groups \
  --load-balancer-arn $LB_ID \
  --region us-east-1 \
  --query "TargetGroups[].TargetGroupArn" \
  --output text)

RESULTS="[]"

for tg_arn in ${TARGET_GROUPS}; do
    TARGET_IDS=$(aws elbv2 describe-target-health \
        --target-group-arn "$tg_arn" \
        --region us-east-1 \
        --query "TargetHealthDescriptions[].Target.Id" \
        --output text)

    for target in $TARGET_IDS; do
        INSTANCE_STATUS=$(aws ec2 start-instances \
            --instance-ids ${target} \
            --region us-east-1 \
            --query "StartingInstances[].CurrentState.Name" \
            --output text)

        RESULT_JSON=$(jq -n \
            --arg targetId "$target" \
            --arg status "$INSTANCE_STATUS" \
            '{targetId: $targetId, status: $status}')

        RESULTS=$(jq -n --argjson results "$RESULTS" --argjson item "$RESULT_JSON" '$results + [$item]')
    done
done

echo "$RESULTS"