OUTPUT_NAME="output-tnieyu-block01-lb-service01"

echo "OUTPUT_NAME=$OUTPUT_NAME"

# 1. Pull file tfstate hiện tại
tf state pull > tmp.tfstate.json
# 2. Xóa key output mong muốn (output-alice-block_01-host-service_01)
jq --arg key "$OUTPUT_NAME" '.serial += 1 | del(.outputs[$key])' tmp.tfstate.json > new.tfstate.json

# 3. Push lại tfstate đã chỉnh sửa
tf state push new.tfstate.json
# 4. Xoá file tạm
rm tmp.tfstate.json new.tfstate.json