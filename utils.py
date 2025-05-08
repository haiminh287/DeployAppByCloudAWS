from config import app
from flask import current_app
from flask_login import current_user
import threading


def run_in_thread(app_context, deploy_service, tfvars_path, updates_new, type_service, **kwargs):
    with app_context:
        deploy_service.apply(tfvars_path, updates_new, type_service, **kwargs)


def run_in_thread_destroy(app_context, deploy_service, type_service, service_id, **kwargs):
    with app_context:
        deploy_service.destroy(type_service, service_id, **kwargs)


def deploy_service_thread(deploy_main_service, tfvars_path, type_service, updates_new, **kwargs):
    with app.app_context():
        app_context = current_app.app_context()
        kwargs['current_user_id'] = current_user.id
        thread = threading.Thread(target=run_in_thread, args=(
            app_context, deploy_main_service, tfvars_path, updates_new, type_service), kwargs=kwargs)
        thread.start()


def destroy_service_thread(deploy_main_service, type_service, service_id, **kwargs):
    with app.app_context():
        app_context = current_app.app_context()
        print("Current User:", current_user)
        kwargs['current_user_id'] = current_user.id
        thread = threading.Thread(target=run_in_thread_destroy, args=(
            app_context, deploy_main_service, type_service, service_id), kwargs=kwargs)
        thread.start()
