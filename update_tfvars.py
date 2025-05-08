import json


class UpdateTfvars:
    def __init__(self, vpc_id, subnet_ids):
        self.vpc_id = vpc_id
        self.subnet_ids = subnet_ids

    def update_tfvars_file(self, file_path, updates):
        with open(file_path, "r", encoding='utf-8') as file:
            lines = file.readlines()

        updated_lines = []
        skip_lines = False
        for line in lines:
            if skip_lines:
                if line.strip() == "EOF":
                    skip_lines = False
                continue
            for key, value in updates.items():
                if line.startswith(key):
                    if key == "user_data":
                        value = f"<<EOF\n{value}\nEOF"
                        line = f'{key} = {value}\n'
                        print("user_data_s :", f'{key} = {value}\n')
                        skip_lines = True
                    elif isinstance(value, list):
                        value = "[" + ", ".join(
                            f'"{v}"' if isinstance(v, str) else str(v) for v in value
                        ) + "]"
                    elif isinstance(value, dict):
                        value = json.dumps(value, indent=2).replace(
                            '"', '\\"').replace("'", '"')
                    elif isinstance(value, str):
                        value = f'"{value}"'
                    if key == "rules":
                        value = str(value).replace("'", '"')
                    line = f'{key} = {value}\n'
                    break

            updated_lines.append(line)
        with open(file_path, "w", encoding='utf-8', newline='') as file:
            file.writelines(updated_lines)

    def final_tfvars(self, tfvars_path, updates_new):
        updates = {
            "vpc_id": self.vpc_id,
            "subnet_ids": self.subnet_ids,
        }
        updates.update(updates_new)
        self.update_tfvars_file(tfvars_path, updates)
