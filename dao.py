import hashlib
from models import User, Block, HostService, RDSService
from config import db
from flask_login import current_user
from sqlalchemy import text


def auth_user(username, password, role=None):
    password = str(hashlib.md5(password.encode('utf-8')).hexdigest())

    u = User.query.filter(User.username.__eq__(username),
                          User.password.__eq__(password))
    if role:
        u = u.filter(User.user_role.__eq__(role))
    print("user", u.first())
    return u.first()


def get_user_by_id(id):
    return User.query.get(id)


def create_block():
    block = Block(user_id=current_user.id)
    db.session.add(block)
    db.session.commit()
    return block


def get_blocks():
    return Block.query.filter(Block.user_id.__eq__(current_user.id)).all()


def create_host_service(url_github, text_script_run, type_ec2, block_id, vm_type, load_balancer_counter, public_ip, service_id, key_pair, url_web_load_balancer=None):
    host_service = HostService(url_github=url_github, text_script_run=text_script_run, type_ec2=type_ec2,
                               block_id=block_id, vm_type=vm_type, load_balancer_counter=load_balancer_counter, public_ip=public_ip, service_id=service_id, url_web_load_balancer=url_web_load_balancer, key_pair=key_pair)
    db.session.add(host_service)
    db.session.commit()
    return host_service


def create_rds_service(database_name, username, password, type_database, block_id, host, port, service_id):
    rds_service = RDSService(database_name=database_name, username=username,
                             password=password, type_database=type_database, block_id=block_id, host=host, port=port, service_id=service_id)
    db.session.add(rds_service)
    db.session.commit()
    return rds_service


def get_host_service_by_block_id(block_id):
    return HostService.query.filter(HostService.block_id.__eq__(block_id)).all()


def get_rds_service_by_block_id(block_id):
    return RDSService.query.filter(RDSService.block_id.__eq__(block_id)).all()


def get_last_id_rds_service():
    result = db.session.execute(
        text("""
            SELECT AUTO_INCREMENT 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'rds_services' 
              AND TABLE_SCHEMA = 'cloudcomputingdb'
        """)
    )
    next_id = result.scalar()
    return next_id


def get_last_id_host_service():
    result = db.session.execute(
        text("""
            SELECT AUTO_INCREMENT 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'host_services' 
              AND TABLE_SCHEMA = 'cloudcomputingdb'
        """)
    )
    next_id = result.scalar()
    return next_id


def get_rds_service_by_id(id):
    return RDSService.query.get(id)


def get_host_service_by_id(id):
    return HostService.query.get(id)


def delete_rds_service_by_id(id):
    rds_service = RDSService.query.get(id)
    if rds_service:
        db.session.delete(rds_service)
        db.session.commit()
        return True
    return False


def delete_host_service_by_id(id):
    host_service = HostService.query.get(id)
    if host_service:
        db.session.delete(host_service)
        db.session.commit()
        return True
    return False


def update_tfvars_file(file_path, updates):
    with open(file_path, "r") as file:
        lines = file.readlines()

    updated_lines = []
    for line in lines:
        for key, value in updates.items():
            if line.startswith(key):
                if isinstance(value, (list, dict)):
                    import json
                    value = json.dumps(value).replace("'", '"')
                line = f'{key} = {value}\n' if isinstance(
                    value, (list, dict)) else f'{key} = "{value}"\n'
                break
        updated_lines.append(line)

    with open(file_path, "w") as file:
        file.writelines(updated_lines)


# if __name__ == "__main__":
#     from config import app
#     with app.app_context():
#         print(get_last_id_rds_service())
