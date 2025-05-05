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

# # code run final

# MODULE_NAME=$(grep -oP 'module "\K[^"]+' "$OUTPUT_FILE")
# echo "$MODULE_NAME"

# TARGET="module.$MODULE_NAME"
# tf destroy -target=${TARGET} -var-file=${TFVARS_FILE} --auto-approve
# rm "$OUTPUT_FILE"

# tf init

# #

exit 0