

from update_tfvars import UpdateTfvars
from service_run_cmd import ServiceRunCmd
from flask_login import current_user
import dao


class DeployService:
    def __init__(self, block_id):
        self.block_id = block_id
        self.service_run = ServiceRunCmd()
        self.vpc_id = self.service_run.get_vpc()
        self.update_main_tfvars = UpdateTfvars(
            self.vpc_id, self.service_run.get_subnets(self.vpc_id))

    def apply(self, file_tfvars_path, updates_new, type_service, **kwargs):
        self.update_main_tfvars.final_tfvars(
            tfvars_path=file_tfvars_path,
            updates_new=updates_new
        )
        last_id_service = dao.get_last_id(f"{type_service}_services")
        output_path = f"./{type_service}_template_{last_id_service}.tf"
        # print("currnet_user:", current_user)
        self.service_run.run_generate_template(user_id="u{}".format(kwargs['current_user_id']), block_id=str(self.block_id),
                                               service_template=f"{type_service}_template.tf",
                                               service_tfvars=f"{type_service}.tfvars",
                                               last_id_service=str(
            last_id_service),
            output_path=output_path,
            type="apply")

        output = self.service_run.get_output(user_id="u{}".format(kwargs['current_user_id']), block_id=str(
            self.block_id), last_id_service=str(last_id_service), type_service=type_service)
        if type_service == 'rds':
            print("OUTPUT:", output)
            dao.create_rds_service(username=output["rds"]["detail_infos"]["username"], password=output["rds"]["detail_infos"]["password"],
                                   database_name=output["rds"]["detail_infos"]["db_name"], type_database=output["rds"]["detail_infos"]["engine"], block_id=self.block_id, host=output[
                                       "rds"]["detail_infos"]["host"],
                                   port=output["rds"]["detail_infos"]["port"], service_id=output["rds"]["id"])
        elif type_service == 'host':
            dao.create_host_service(kwargs['url_github'], kwargs['text_script_run'], kwargs['type_ec2'],
                                    self.block_id, kwargs['vm_type'],
                                    output["ec2"]["detail_infos"]["public-ip"],
                                    service_id=output["ec2"]["id"], key_pair=output["key_pair"]["detail_infos"]["public_key"])
        elif type_service == 'lb':
            dao.create_load_balancer_service(output, block_id=self.block_id,
                                             user_data=kwargs['user_data'], host_ports=kwargs['host_ports'])

    def destroy(self, type_service, service_id, **kwargs):
        print("DELETE SERVICE_ID:", service_id)
        output_path = f"./{type_service}_template_{service_id}.tf"
        self.service_run.run_generate_template(user_id="u{}".format(kwargs['current_user_id']), block_id=str(self.block_id),
                                               service_template=f"{type_service}_template.tf",
                                               service_tfvars=f"{type_service}.tfvars",
                                               last_id_service=str(
            service_id),
            output_path=output_path,
            type="destroy")
        dao.delete_service_by_id(type_service, service_id)

    def get_state(self, type_service, service_id):
        return self.service_run.get_state(type_service, service_id)
