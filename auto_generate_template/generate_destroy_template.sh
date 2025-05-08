#!/bin/bash

# Mặc định: input/output file rỗng
INPUT_FILE=""
OUTPUT_FILE=""
USER_ID=""
BLOCK_ID=""
SERVICE_ID=""
TFVARS_FILE=""

while getopts "f:o:u:b:s:v:" opt; do
  case $opt in
    f) INPUT_FILE="$OPTARG" ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    u) USER_ID="$OPTARG" ;;
    b) BLOCK_ID="$OPTARG" ;;
    s) SERVICE_ID="$OPTARG" ;;
    v) TFVARS_FILE="$OPTARG" ;;
    \?)
      echo "Usage: $0 -f <input_file> -o <output_file> -u <user_id> -b <block_id> -s <service_id>"
      exit 1 ;;
  esac
done

if [[ -z "$INPUT_FILE" || -z "$OUTPUT_FILE" || -z "$USER_ID" || -z "$BLOCK_ID" || -z "$SERVICE_ID" || -z "$TFVARS_FILE" ]]; then
  echo "Missing required arguments."
  echo "Usage: $0 -f <input_file> -o <output_file> -u <user_id> -b <block_id> -s <service_id> -v <tfvars_file>"
  exit 1
fi

sed -e "s/_2_user_id_2_/${USER_ID}/g" \
    -e "s/_2_block_id_2_/${BLOCK_ID}/g" \
    -e "s/_2_service_id_2_/${SERVICE_ID}/g" \
    "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Generated: $OUTPUT_FILE"

# code run final

MODULE_NAME=$(grep -oP 'module "\K[^"]+' "$OUTPUT_FILE")
echo "MODULE_NAME: $MODULE_NAME"

TARGET="module.$MODULE_NAME"
tf destroy -target=${TARGET} -var-file=${TFVARS_FILE} -lock=false --auto-approve

rm "$OUTPUT_FILE"


SERVICE_TYPE=$(echo "$MODULE_NAME" | awk -F'-' '{print $3}')
echo "SERVICE_TYPE: $SERVICE_TYPE"

OUTPUT_TEMPLATE_PATH="./output_template/output_template.tf"
OUTPUT_TEMPLATE_FILE="./output_file.tf"

sed -e "s/_2_user_id_2_/${USER_ID}/g" \
    -e "s/_2_block_id_2_/${BLOCK_ID}/g" \
    -e "s/_2_service_id_2_/${SERVICE_ID}/g" \
    -e "s/_2_service_type_2_/${SERVICE_TYPE}/g" \
    "$OUTPUT_TEMPLATE_PATH" > "$OUTPUT_TEMPLATE_FILE"

OUTPUT_NAME=$(grep -oP 'output "\K[^"]+' "$OUTPUT_TEMPLATE_FILE")
echo "OUTPUT_NAME: $OUTPUT_NAME"

# 1. Pull file tfstate hiện tại
tf state pull > tmp.tfstate.json
# 2. Xóa key output mong muốn (output-alice-block_01-host-service_01)
jq --arg key "$OUTPUT_NAME" '.serial += 1 | del(.outputs[$key])' tmp.tfstate.json > new.tfstate.json
# 3. Push lại tfstate đã chỉnh sửa
tf state push new.tfstate.json
# 4. Xoá file tạm
rm tmp.tfstate.json new.tfstate.json

rm "$OUTPUT_TEMPLATE_FILE"

tf init

#

exit 0