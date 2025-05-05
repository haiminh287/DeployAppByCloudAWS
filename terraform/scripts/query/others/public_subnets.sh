aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=vpc-06f579c2c7152f998" \
  --region us-east-1 \
  --query "Subnets[?contains(Tags[?Key=='Name'].Value | [0], 'public')].SubnetId" \
  --output json