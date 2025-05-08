import os
import subprocess
import json
import threading


class ServiceRunCmd:
    def __init__(self):
        self.target_directory = r"F:\Projects\RealityProjects\DeployAppByCloudAWS"
        self.bash_path = "C:/Git_Py_Setup/Git/Git/bin/bash.exe"

    def run_command(self, command):
        try:
            result = subprocess.run(
                command, check=True, text=True, capture_output=True, cwd=self.target_directory
            )
            print("Command Output:", result.stdout)
            print("Command Error:", result.stderr)
            try:
                return json.loads(result.stdout)
            except json.JSONDecodeError:
                return result.stdout
        except subprocess.CalledProcessError as e:
            print(
                f"Error: Command '{e.cmd}' failed with return code {e.returncode}")
            print(f"Error Output: {e.stderr}")
            return None

    def run_generate_template(
        self, user_id, block_id, service_template, service_tfvars, last_id_service, output_path, type
    ):
        command = [self.bash_path] + [
            f"auto_generate_template/generate_{type}_template.sh",
            "-f", f"service_template/{service_template}",
            "-o", output_path,
            "-u", user_id,
            "-b", block_id,
            "-s", last_id_service,
            "-v", f"service_tfvars/{service_tfvars}",
        ]
        return self.run_command(command)

    def get_output(self, user_id, block_id, last_id_service, type_service):
        output_name = f"output-{user_id}-{block_id}-{type_service}-{last_id_service}"
        command = ["tf", "output", "-json", output_name]
        return self.run_command(command)

    def get_info(self, command):
        command = [self.bash_path] + command.split()
        return self.run_command(command)

    def get_vpc(self):
        return self.get_info("terraform/scripts/query/others/vpc_ids.sh")[0]

    def get_subnets(self, vpc_id):
        return self.get_info(
            "terraform/scripts/query/others/public_subnets.sh -i {}".format(vpc_id))

    def get_state(self, type_service, service_id):
        command = [self.bash_path] + [
            f"terraform/scripts/query/{type_service}/get_state.sh",
            "-i", service_id
        ]
        return self.run_command(command)
    
    def disable_service(self, type_service, service_id):
        command = [self.bash_path] + [
            f"terraform/scripts/query/{type_service}/stop_service.sh",
            "-i", service_id
        ]
        return self.run_command(command=command)
    
    def enable_service(self, type_service, service_id):
        command = [self.bash_path] + [
            f"terraform/scripts/query/{type_service}/load_service.sh",
            "-i", service_id
        ]
        return self.run_command(command=command)
    
    def get_importance_data_service(self, type_service, service_id):
        command = [self.bash_path] + [
            f"terraform/scripts/query/{type_service}/get_importance_data.sh",
            "-i", service_id
        ]
        return self.run_command(command=command)
