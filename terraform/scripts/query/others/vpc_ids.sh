
aws ec2 describe-vpcs \
    --region us-east-1 \
    --query "Vpcs[?Tags[?Key=='Name'] | [0]].VpcId" \
    --output json