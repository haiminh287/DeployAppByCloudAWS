import json
import random

class UpdateTfvars:
    def __init__(self, vpc_id, subnet_ids):
        self.vpc_id = vpc_id
        self.subnet_ids = subnet_ids

    def update_tfvars_file(self, file_path, updates):
        with open(file_path, "r", encoding='utf-8') as file:
            lines = file.readlines()

        updated_lines = []
        skip_lines = False
        skip_sg_rules_block = False  # <== flag skip sg_rules

        for line in lines:
            if skip_lines:
                if line.strip() == "EOF":
                    skip_lines = False
                continue

            if skip_sg_rules_block:
                if line.strip() == "}":
                    skip_sg_rules_block = False
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
                        if key == "sg_rules":
                            terraform_sg_rules = []
                            for rule_key, rule_value in value.items():
                                terraform_rule = f'  "{rule_key}" = {{\n'
                                for sub_key, sub_value in rule_value.items():
                                    if isinstance(sub_value, list):
                                        sub_value = "[" + ", ".join(
                                            f'"{v}"' if isinstance(v, str) else str(v) for v in sub_value
                                        ) + "]"
                                    elif isinstance(sub_value, str):
                                        sub_value = f'"{sub_value}"'
                                    else:
                                        sub_value = str(sub_value)
                                    terraform_rule += f'    {sub_key} = {sub_value}\n'
                                terraform_rule += "  }"
                                terraform_sg_rules.append(terraform_rule)

                            value = "{\n" + \
                                "\n".join(terraform_sg_rules) + "\n}"
                            value = value.rstrip('}')
                            line = f'{key} = {value}\n}}\n'
                            skip_sg_rules_block = True
                        else:
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
            "subnet_id": random.choice(self.subnet_ids)
        }
        updates.update(updates_new)
        self.update_tfvars_file(tfvars_path, updates)
