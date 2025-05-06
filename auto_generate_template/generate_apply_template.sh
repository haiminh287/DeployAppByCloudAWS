#!/bin/bash

# Mặc định: input/output file rỗng
INPUT_FILE=""
OUTPUT_FILE=""
USER_ID=""
BLOCK_ID=""
SERVICE_ID=""
SERVICE_TYPE=""
TFVARS_FILE=""

while getopts "f:o:u:b:s:t:v:" opt; do
  case $opt in
    f) INPUT_FILE="$OPTARG" ;;
    o) OUTPUT_FILE="$OPTARG" ;;
    u) USER_ID="$OPTARG" ;;
    b) BLOCK_ID="$OPTARG" ;;
    s) SERVICE_ID="$OPTARG" ;;
    t) SERVICE_TYPE="$OPTARG" ;;
    v) TFVARS_FILE="$OPTARG" ;;
    \?)
      echo "Usage: $0 -f <input_file> -o <output_file> -u <user_id> -b <block_id> -s <service_id> -t <service_type> -v <tfvars_file>"
      exit 1 ;;
  esac
done

if [[ -z "$INPUT_FILE" || -z "$OUTPUT_FILE" || -z "$USER_ID" || -z "$BLOCK_ID" || -z "$SERVICE_ID" || -z "$SERVICE_TYPE" || -z "$TFVARS_FILE" ]]; then
  echo "Missing required arguments."
  echo "Usage: $0 -f <input_file> -o <output_file> -u <user_id> -b <block_id> -s <service_id> -t <service_type> -v <tfvars_file>"
  exit 1
fi

sed -e "s/_2_user_id_2_/${USER_ID}/g" \
    -e "s/_2_block_id_2_/${BLOCK_ID}/g" \
    -e "s/_2_service_id_2_/${SERVICE_ID}/g" \
    -e "s/_2_service_type_2_/${SERVICE_TYPE}/g" \
    "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Generated: $OUTPUT_FILE"

# code run final

OUTPUT_TEMPLATE_PATH="./output_template/output_template.tf"
OUTPUT_TEMPLATE_FILE="./output_file.tf"

sed -e "s/_2_user_id_2_/${USER_ID}/g" \
    -e "s/_2_block_id_2_/${BLOCK_ID}/g" \
    -e "s/_2_service_id_2_/${SERVICE_ID}/g" \
    -e "s/_2_service_type_2_/${SERVICE_TYPE}/g" \
    "$OUTPUT_TEMPLATE_PATH" > "$OUTPUT_TEMPLATE_FILE"

OUTPUT_NAME=$(grep -oP 'output "\K[^"]+' "$OUTPUT_TEMPLATE_FILE")


MODULE_NAME=$(grep -oP 'module "\K[^"]+' "$OUTPUT_FILE")
echo "$MODULE_NAME"

TARGET="module.$MODULE_NAME"
tf init
tf apply -target=${TARGET} -var-file=${TFVARS_FILE} --auto-approve

echo "$OUTPUT_NAME"


rm "$OUTPUT_TEMPLATE_FILE"
rm "$OUTPUT_FILE"

#

exit 0