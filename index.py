import subprocess
from config import app, login
from flask import render_template, request, jsonify, session, redirect, url_for
import dao
from flask_login import login_user, logout_user, login_required
from models import EC2Type, VMTypeEnum, TypeDatabaseEnum
import os
from flask_login import current_user
from service_run_cmd import ServiceRunCmd

service_run = ServiceRunCmd()


@app.route('/')
def index() -> str:
    return render_template("index.html", blocks=dao.get_blocks())


@app.route("/login", methods=['get', 'post'])
def login_view():
    if request.method.__eq__('POST'):
        username = request.form.get('username')
        password = request.form.get('password')
        user = dao.auth_user(username=username, password=password)
        print("USER:", user)
        if user:
            login_user(user=user, remember=True)

            next = request.args.get('next')
            return redirect(next if next else '/')

    return render_template('login.html')


@app.route('/logout')
def logout_process():
    logout_user()
    return redirect('/login')


@app.route('/blocks', methods=['POST'])
def create_block():
    block = dao.create_block()
    return jsonify({"block_id": block.id, "created_at": block.created_at, "updated_at": block.updated_at})


@app.route('/blocks/<int:block_id>', methods=['GET'])
@login_required
def get_block(block_id):
    host_service = dao.get_host_service_by_block_id(block_id)
    rds_service = dao.get_rds_service_by_block_id(block_id)
    return render_template('block.html', block_id=block_id, rds_service=rds_service, host_service=host_service)


@app.route('/blocks/<int:block_id>/services/<int:service_id>', methods=['GET'])
@login_required
def get_service(block_id, service_id):
    service_mapping = {
        1: {
            "service": dao.get_host_service_by_block_id(block_id),
            "detail_template": 'host_service_detail.html',
            "default_template": 'host_service.html'
        },
        2: {
            "service": dao.get_rds_service_by_block_id(block_id),
            "detail_template": 'rds_service_detail.html',
            "default_template": 'rds_service.html'
        }
    }

    service_data = service_mapping.get(service_id)
    if service_data:
        if service_data["service"]:
            return render_template(service_data["detail_template"], service=service_data["service"])
        return render_template(service_data["default_template"], block_id=block_id)

    return render_template('block.html', block_id=block_id)


@app.route('/blocks/<int:block_id>/host-services', methods=['GET', 'POST'])
def host_service(block_id):
    if request.method.__eq__('POST'):
        url_github = request.form.get('url_github')
        text_script_run = request.form.get('text_script_run')
        ec2_type = request.form.get('ec2_type')
        vm_type = request.form.get('vm_type')
        ec2_type = EC2Type(ec2_type)
        vm_type = VMTypeEnum(vm_type)
        load_balancer_counter = int(request.form.get('load_balancer_count', 0))
        vpc_id = service_run.get_vpc()
        subnet_id = service_run.get_subnet(vpc_id)[0]
        file_path = r"C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\service_tfvars\host.tfvars"

        dao.update_tfvars_file(
            file_path=file_path,
            updates={
                "vpc_id": vpc_id,
                "subnet_id": subnet_id,
                "user_data": text_script_run
            }
        )
        if load_balancer_counter == 0:

            last_id_service = dao.get_last_id_host_service()
            rds_output_path = "./host_template_{}.tf".format(last_id_service)

            service_run.run_generate_template(user_id="u{}".format(current_user.id), block_id=str(block_id),
                                              service_template="host_template.tf",
                                              service_tfvars="host.tfvars",
                                              last_id_service=str(
                last_id_service),
                output_path=rds_output_path,
                type="apply")

            output = service_run.get_output(user_id="u{}".format(current_user.id), block_id=str(
                block_id), last_id_service=str(last_id_service), type_service="host")
            if output:
                dao.create_host_service(url_github=url_github, text_script_run=text_script_run, type_ec2=ec2_type,
                                        block_id=block_id, vm_type=vm_type, load_balancer_counter=load_balancer_counter,
                                        public_ip=output["ec2"]["detail_infos"]["public-ip"],
                                        service_id=output["ec2"]["id"], key_pair=output["key_pair"]["detail_infos"]["public_key"])
    host_services = dao.get_host_service_by_block_id(block_id)
    print("HOST_SERVICE:", host_services)
    return render_template('host_service.html', host_services=host_services, block_id=block_id)


@app.route('/host-services/<int:host_service_id>', methods=['DELETE'])
def delete_host_service(host_service_id):
    if request.method.__eq__('DELETE'):
        print("DELETE HOST_SERVICE_ID:", host_service_id)
        host_service = dao.get_host_service_by_id(host_service_id)
        print("HOST_SERVICE:", host_service)
        host_output_path = "./host_template_{}.tf".format(host_service_id)
        service_run.run_generate_template(user_id="u{}".format(current_user.id), block_id=str(host_service.block_id),
                                          service_template="host_template.tf",
                                          service_tfvars="host.tfvars",
                                          last_id_service=str(
            host_service_id),
            output_path=host_output_path,
            type="destroy")
        dao.delete_host_service_by_id(host_service_id)
        return jsonify({"status": "success", "message": "Host service deleted successfully"})


@app.route('/blocks/<int:block_id>/host-services-form', methods=['GET'])
def form_host_service(block_id):
    return render_template('host_service_form.html', block_id=block_id)


@app.route('/blocks/<int:block_id>/rds-services-form', methods=['GET'])
def form_rds_service(block_id):
    return render_template('rds_service_form.html', block_id=block_id)


@app.route('/blocks/<int:block_id>/rds-services', methods=['GET', 'POST'])
def rds_service(block_id):
    if request.method.__eq__('POST'):
        username = request.form.get('username')
        password = request.form.get('password')
        database_name = request.form.get('database_name')
        type_database = request.form.get('type_database')
        type_database = TypeDatabaseEnum(type_database)

        tfvars_rds_path = r"C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\service_tfvars\rds.tfvars"
        vpc_id = service_run.get_vpc()
        subnet_ids = service_run.get_subnet(vpc_id)

        dao.update_tfvars_file(file_path=tfvars_rds_path, updates={
            "db_name": database_name,
            "user_name": username,
            "password": password,
            "engine": type_database,
            "vpc_id": vpc_id,
            "subnet_ids": subnet_ids
        })
        last_id_service = dao.get_last_id_rds_service()
        rds_output_path = "./rds_template_{}.tf".format(last_id_service)

        service_run.run_generate_template(user_id="u{}".format(current_user.id), block_id=str(block_id),
                                          service_template="rds_template.tf",
                                          service_tfvars="rds.tfvars",
                                          last_id_service=str(
                                              last_id_service),
                                          output_path=rds_output_path,
                                          type="apply")

        output = service_run.get_output(user_id="u{}".format(current_user.id), block_id=str(
            block_id), last_id_service=str(last_id_service), type_service="rds")
        if output:
            dao.create_rds_service(username=username, password=password,
                                   database_name=database_name, type_database=type_database, block_id=block_id, host=output["host"], port=output["port"], service_id=output["id"])
        return redirect(f'/blocks/{block_id}')

    rds_services = dao.get_rds_service_by_block_id(block_id)
    print("RDS_SERVICES:", rds_services)
    return render_template('rds_service.html', rds_services=rds_services, block_id=block_id)


@app.route('/rds-services/<int:rds_service_id>', methods=['DELETE'])
def delete_rds_service(rds_service_id):
    if request.method.__eq__('DELETE'):
        rds_service = dao.get_rds_service_by_id(rds_service_id)
        rds_output_path = "./rds_template_{}.tf".format("2")
        service_run.run_generate_template(user_id="u{}".format(current_user.id), block_id=str(rds_service.block_id),
                                          service_template="rds_template.tf",
                                          service_tfvars="rds.tfvars",
                                          last_id_service=str(
            rds_service_id),
            output_path=rds_output_path,
            type="destroy")
        dao.delete_rds_service_by_id(rds_service_id)


@login.user_loader
def load_user(user_id):
    return dao.get_user_by_id(user_id)


if __name__ == '__main__':
    import admin
    app.run(debug=True)
