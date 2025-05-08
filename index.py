from flask import current_app
import threading
from config import app, login
from flask import render_template, request, jsonify, session, redirect, url_for
import dao
from flask_login import login_user, logout_user, login_required
from models import EC2Type, VMTypeEnum, TypeDatabaseEnum
import os
from flask_login import current_user
from deploy_service import DeployService
import utils
import json
from typing import Callable


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
    host_service = dao.get_host_services_by_block_id(block_id)
    rds_service = dao.get_rds_services_by_block_id(block_id)
    lb_service = dao.get_lb_services_by_block_id(block_id)
    return render_template('block.html', block_id=block_id, rds_service=rds_service, host_service=host_service, lb_service=lb_service)


@app.route('/blocks/<int:block_id>/services/<int:service_id>', methods=['GET'])
@login_required
def get_service(block_id, service_id):
    service_mapping = {
        1: {
            "service": dao.get_host_services_by_block_id(block_id),
            "detail_template": 'host_service_detail.html',
            "default_template": 'host_service.html'
        },
        2: {
            "service": dao.get_rds_services_by_block_id(block_id),
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


# Load Balancer Service

@app.route('/blocks/<int:block_id>/lb-services', methods=['GET'])
def lb_service(block_id):
    load_balancers = dao.get_lb_services_by_block_id(block_id)
    return render_template('lb_service.html', load_balancers=load_balancers)


@app.route('/lb-services/<int:lb_service_id>', methods=['GET', 'POST', 'DELETE'])
def delete_lb_service(lb_service_id):
    service = dao.get_service_by_id("lb", lb_service_id)
    deploy_main_service = DeployService(service.block_id)
    if request.method.__eq__('DELETE'):
        utils.destroy_service_thread(
            deploy_main_service, "lb", lb_service_id)
        return jsonify({"status": "success", "message": "LB service deleted successfully"})
    if request.method.__eq__('POST'):
        deploy_main_service.stop("lb", service.service_id)
        dao.updateState("lb", lb_service_id, "stopped")
        return jsonify({"status": "success", "state": "stopped"})

    targets = deploy_main_service.get_state("lb", service.service_id)
    print("TARGETS:", targets)
    return render_template('lb_service_detail.html', targets=targets)


#  Host Service


@app.route('/blocks/<int:block_id>/host-services', methods=['GET', 'POST'])
def host_service(block_id):
    status_message = None
    if request.method.__eq__('POST'):
        print("POST HOST_SERVICE")
        url_github = request.form.get('url_github')
        text_script_run = request.form.get('text_script_run')
        ec2_type = request.form.get('ec2_type')
        vm_type = request.form.get('vm_type')
        ec2_type = EC2Type(ec2_type)
        vm_type = VMTypeEnum(vm_type)
        load_balancer_counter = int(request.form.get('load_balancer_count', 0))
        port = request.form.get('port')
        tfvars_host_path = r"C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\service_tfvars\host.tfvars"
        deploy_main_service = DeployService(block_id)
        if load_balancer_counter == 0:
            sg_rules = {
                "flask": {
                    "from_port": port,
                    "to_port": port,
                    "protocol": "tcp",
                    "cidr_blocks": ["0.0.0.0/0"]
                }
            }
            updates_new = {
                "user_data": text_script_run,
                "subnet_id": deploy_main_service.service_run.get_subnets(deploy_main_service.vpc_id)[0],
                "sg_rules": sg_rules
            }

            utils.deploy_service_thread(
                deploy_main_service, tfvars_host_path, "host", updates_new, url_github=url_github, text_script_run=text_script_run, type_ec2=ec2_type,
                block_id=block_id, vm_type=vm_type, port=port)
            status_message = "Đang tạo dịch vụ Host, vui lòng đợi..."
        else:
            tfvars_lb_path = r"C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\service_tfvars\lb.tfvars"
            host_ports = []
            rules = []
            for i in range(load_balancer_counter):
                port = int(request.form.get('port_{}'.format(i+1)))
                print("PORT:", port)
                host_ports.append(port)
                if not any(rule["from_port"] == port for rule in rules):
                    rules.append({
                        "from_port": port,
                        "to_port": port,
                        "listener_protocol": "tcp",
                        "host_protocol": "tcp",
                        "cidr_blocks": ["0.0.0.0/0"]
                    })
            updates_new = {
                "host_ports": host_ports,
                "rules": rules,
                "user_data": text_script_run,
            }
            utils.deploy_service_thread(
                deploy_main_service, tfvars_lb_path, "lb", updates_new, user_data=text_script_run, host_ports=host_ports)
            status_message = "Đang tạo dịch vụ Load Balancer, vui lòng đợi..."

    host_services = dao.get_host_services_by_block_id(block_id)
    print("HOST_SERVICE:", host_services)
    return render_template('host_service.html', host_services=host_services, block_id=block_id, status_message=status_message)


@app.route('/host-services/<int:host_service_id>', methods=['DELETE'])
def delete_host_service(host_service_id):
    service = dao.get_service_by_id("host", host_service_id)
    deploy_main_service = DeployService(service.block_id)
    if request.method.__eq__('DELETE'):
        utils.destroy_service_thread(
            deploy_main_service, "host", host_service_id)
        return jsonify({"status": "success", "message": "Host service deleted successfully"})


@app.route('/host-services/<int:host_service_id>/state', methods=['POST'])
def get_state_host_service(host_service_id):
    def update_exec(old_obj: any,
                    service_id: int,
                    type_service: str,
                    obj: dict) -> any:
        old_obj.public_ip = obj.get("publicIP")

        if not dao.update_service_by_id(type_service, service_id, obj):
            raise Exception("update service obj is error")

    return get_state_service(
        service_id=host_service_id,
        type_service="host",
        get_state_exec_structure=get_and_update_status_for_service_mixin,
        update_exec_structure=update_exec
    )


@app.route('/host-services/<int:host_service_id>/disable', methods=['POST'])
def disable_host_service(host_service_id):
    def update_exec(old_obj: any,
                    service_id: int,
                    type_service: str,
                    obj: dict) -> any:
        old_obj.public_ip = obj.get("publicIP")

        if not dao.update_service_by_id(type_service, service_id, obj):
            raise Exception("update service obj is error")

    return disable_service(
        service_id=host_service_id,
        type_service="host",
        disable_exec_structure=get_and_update_status_for_service_mixin,
        update_exec_structure=update_exec
    )


@app.route('/host-services/<int:host_service_id>/enable', methods=['POST'])
def enable_host_service(host_service_id):
    return enable_service(
        service_id=host_service_id,
        type_service="host",
        enable_exec_structure=get_and_update_status_for_service_mixin
    )


@app.route('/blocks/<int:block_id>/host-services-form', methods=['GET'])
def form_host_service(block_id):
    return render_template('host_service_form.html', block_id=block_id)


# RDS Service

@app.route('/blocks/<int:block_id>/rds-services-form', methods=['GET'])
def form_rds_service(block_id):
    return render_template('rds_service_form.html', block_id=block_id)


@app.route('/blocks/<int:block_id>/rds-services', methods=['GET', 'POST'])
def rds_service(block_id):
    status_message = None
    if request.method.__eq__('POST'):
        username = request.form.get('username')
        password = request.form.get('password')
        database_name = request.form.get('database_name')
        type_database = request.form.get('type_database')
        type_database = TypeDatabaseEnum(type_database)

        tfvars_rds_path = r"C:\Users\MINH\Documents\Zalo_Received_Files\MyTFAWS1\service_tfvars\rds.tfvars"
        updates_new = {
            "db_name": database_name,
            "user_name": username,
            "password": password,
            "engine": type_database.value,
        }
        deploy_main_service = DeployService(block_id)

        utils.deploy_service_thread(
            deploy_main_service, tfvars_rds_path, "rds", updates_new)

        status_message = "Đang tạo dịch vụ RDS, vui lòng đợi..."
    print("status_message:", status_message)
    rds_services = dao.get_rds_services_by_block_id(block_id)
    return render_template('rds_service.html', rds_services=rds_services, block_id=block_id, status_message=status_message)


@app.route('/rds-services/<int:rds_service_id>', methods=['POST', 'DELETE'])
def delete_rds_service(rds_service_id):
    service = dao.get_service_by_id("rds", rds_service_id)
    deploy_main_service = DeployService(service.block_id)
    if request.method.__eq__('DELETE'):
        utils.destroy_service_thread(
            deploy_main_service, "rds", rds_service_id)
        return jsonify({"status": "success", "message": "RDS service deleted successfully"})
    if request.method.__eq__('POST'):
        deploy_main_service.stop("rds", service.service_id)
        dao.updateState("rds", rds_service_id, "stopped")
        return jsonify({"status": "success", "state": "stopped"})


@app.route('/rds-services/<int:rds_service_id>/state', methods=['POST'])
def get_state_rds_service(rds_service_id):
    def update_exec(old_obj: any,
                    service_id: int,
                    type_service: str,
                    obj: dict) -> any:
        old_obj.url_host = obj.get("endpoint").get("Address")
        old_obj.port = obj.get("endpoint").get("Port")

        if not dao.update_service_by_id(type_service, service_id, obj):
            raise Exception("update service obj is error")

    return get_state_service(
        service_id=rds_service_id,
        type_service="rds",
        get_state_exec_structure=get_and_update_status_for_service_mixin,
        update_exec_structure=update_exec
    )


@app.route('/rds-services/<int:rds_service_id>/disable', methods=['POST'])
def disable_rds_service(rds_service_id):
    def update_exec(old_obj: any,
                    service_id: int,
                    type_service: str,
                    obj: dict) -> any:
        old_obj.url_host = obj.get("endpoint").get("Address")
        old_obj.port = obj.get("endpoint").get("Port")

        if not dao.update_service_by_id(type_service, service_id, obj):
            raise Exception("update service obj is error")

    return disable_service(
        service_id=rds_service_id,
        type_service="rds",
        disable_exec_structure=get_and_update_status_for_service_mixin,
        update_exec_structure=update_exec
    )


@app.route('/rds-services/<int:rds_service_id>/enable', methods=['POST'])
def enable_rds_service(rds_service_id):
    return enable_service(
        service_id=rds_service_id,
        type_service="rds",
        enable_exec_structure=get_and_update_status_for_service_mixin
    )

# func mixin.


def get_and_update_status_for_service_mixin(service_id: int,
                                            type_service: str,
                                            obj: dict) -> str:
    state = obj.get("status")

    print("current_state:" + state)

    if not dao.updateState(type_service, service_id, state):
        raise Exception("update status is error")
    return state


def enable_service(service_id: int, type_service: str,
                   #    data_structure: Callable[[DeployService, Callable, Callable], any],
                   enable_exec_structure: Callable[[int, str, dict], str]):
    service = dao.get_service_by_id(type_service, service_id)
    deploy_main_service = DeployService(service.block_id)
    if request.method.__eq__('POST') and service:
        msg = ""

        state = "empty"
        state_obj = deploy_main_service.enable_service(
            type_service, service.service_id)[0]
        try:
            state = enable_exec_structure(service_id, type_service, state_obj)
        except Exception as ex:
            msg = "update state for service is error"

        if msg != "":
            return jsonify({"status": "fail", "state": "error", "msg": msg})

        return jsonify({"status": "success", "state": state})
    pass


def get_state_service(service_id: int, type_service: str,
                      get_state_exec_structure: Callable[[int, str, dict], str],
                      update_exec_structure: Callable[[any, int, str, dict], any]):
    service = dao.get_service_by_id(type_service, service_id)
    deploy_main_service = DeployService(service.block_id)
    if request.method.__eq__('POST') and service:
        msg = ""

        state = "empty"
        state_obj = deploy_main_service.get_state(
            type_service, service.service_id)[0]
        print("STATE_OBJ:", state_obj)
        try:
            state = get_state_exec_structure(
                service_id, type_service, state_obj)
            print("STATE:", state)
        except Exception as ex:
            msg = "update state for service is error"

        im_data = deploy_main_service.get_importance_data_service(
            type_service, service.service_id)[0]
        try:
            update_exec_structure(service, service_id, type_service, im_data)
        except Exception as ex:
            msg = "update service object for host is error"

        if msg != "":
            return jsonify({"status": "fail", "state": "error", "msg": msg})

        return jsonify({"status": "success", "state": state})
    pass


def disable_service(service_id: int, type_service: str,
                    #    data_structure: Callable[[DeployService, Callable, Callable], any],
                    disable_exec_structure: Callable[[int, str, dict], str],
                    update_exec_structure: Callable[[any, int, str, dict], any]):
    service = dao.get_service_by_id(type_service, service_id)
    deploy_main_service = DeployService(service.block_id)
    if request.method.__eq__('POST') and service:
        msg = ""

        state = "empty"
        state_obj = deploy_main_service.disable_service(
            type_service, service.service_id)[0]
        try:
            state = disable_exec_structure(service_id, type_service, state_obj)
        except Exception as ex:
            msg = "update state for service is error"

        im_data = deploy_main_service.get_importance_data_service(
            type_service, service.service_id)[0]
        try:
            update_exec_structure(service, service_id, type_service, im_data)
        except Exception as ex:
            msg = "update service object for host is error"

        if msg != "":
            return jsonify({"status": "fail", "state": "error", "msg": msg})

        return jsonify({"status": "success", "state": state})
    pass


@login.user_loader
def load_user(user_id):
    return dao.get_user_by_id(user_id)


if __name__ == '__main__':
    import admin
    app.run(debug=True)
