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
    # echo "Target Group: $tg_arn"

    # Lấy trạng thái health của các target trong target group
    TARGET_HEALTHS=$(aws elbv2 describe-target-health \
        --target-group-arn "$tg_arn" \
        --region us-east-1 \
        --query "TargetHealthDescriptions[].TargetHealth" \
        --output json)
    # echo "TARGET_HEALTHS = $TARGET_HEALTHS"

    TARGET_IDS=$(aws elbv2 describe-target-health \
        --target-group-arn "$tg_arn" \
        --region us-east-1 \
        --query "TargetHealthDescriptions[].Target.Id" \
        --output text)
    
    # echo "TARGET_IDS = $TARGET_IDS"

    INDEX=0

    for target in $TARGET_IDS; do
        # echo "TARGET: $target"

        INSTANCE_STATUS=$(aws ec2 describe-instances \
            --filters "Name=instance-id,Values=$target" \
            --region us-east-1 \
            --query "Reservations[].Instances[].State.Name" \
            --output text)
        
        TARGET_HEALTH=$(echo $TARGET_HEALTHS | jq -r ".[$INDEX]")

        RESULT_JSON=$(jq -n \
            --arg targetId "$target" \
            --arg status "$INSTANCE_STATUS" \
            --argjson health "$TARGET_HEALTH" \
            '{targetId: $targetId, health: $health, status: $status}')

        # echo "RESULT_JSON======="
        # echo "$RESULT_JSON"

        RESULTS=$(jq -n --argjson results "$RESULTS" --argjson item "$RESULT_JSON" '$results + [$item]')

        # echo "Target JSON: $RESULT_JSON"
        INDEX=$((INDEX+1))
    done
done

# echo "========== RESULTS"
echo "$RESULTS"

