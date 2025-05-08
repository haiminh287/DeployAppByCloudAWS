import hashlib
from models import User, Block, HostService, RDSService, LoadBalancer, PortLoadBalancer
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


def create_host_service(url_github, text_script_run, type_ec2, block_id, vm_type, public_ip, service_id, key_pair, url_web_load_balancer=None):
    host_service = HostService(url_github=url_github, text_script_run=text_script_run, type_ec2=type_ec2,
                               block_id=block_id, vm_type=vm_type, public_ip=public_ip, service_id=service_id, url_web_load_balancer=url_web_load_balancer, key_pair=key_pair)
    db.session.add(host_service)
    db.session.commit()
    return host_service


def create_load_balancer_service(data_lb, block_id, user_data, host_ports):
    load_balancer = LoadBalancer(url_web_load_balancer=data_lb["load_balancer"]["detail_infos"]["dns_name"], public_key=data_lb["host_key_pair"]["detail_infos"]["public_key"],
                                 user_data=user_data,
                                 block_id=block_id,  service_id=data_lb["load_balancer"]["id"])
    for port in host_ports:
        port_load_balancer = PortLoadBalancer(
            number=port, load_balancer=load_balancer)
        db.session.add(port_load_balancer)
    db.session.add(load_balancer)
    db.session.commit()
    return load_balancer


def create_rds_service(database_name, username, password, type_database, block_id, host, port, service_id):
    rds_service = RDSService(database_name=database_name, username=username,
                             password=password, type_database=type_database, block_id=block_id, url_host=host, port=port, service_id=service_id)
    db.session.add(rds_service)
    db.session.commit()
    return rds_service


def get_host_services_by_block_id(block_id):
    return HostService.query.filter(HostService.block_id.__eq__(block_id)).all()


def get_rds_services_by_block_id(block_id):
    return RDSService.query.filter(RDSService.block_id.__eq__(block_id)).all()


def get_lb_services_by_block_id(block_id):
    return LoadBalancer.query.filter(LoadBalancer.block_id.__eq__(block_id)).all()


def get_last_id(table_name):
    result = db.session.execute(
        text(f"""
            SELECT AUTO_INCREMENT 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = '{table_name}' 
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


def get_last_id_lb_service():
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


def get_service_by_id(type_service, id):
    service_map = {
        "rds": RDSService,
        "host": HostService,
        "lb": LoadBalancer
    }
    service_class = service_map.get(type_service)
    return service_class.query.get(id) if service_class else None


def delete_service_by_id(type_service, id):
    service_map = {
        "rds": RDSService,
        "host": HostService,
        "lb": LoadBalancer
    }
    service_class = service_map.get(type_service)
    if service_class:
        service = service_class.query.get(id)
        if service:
            db.session.delete(service)
            db.session.commit()
            return True
    return False


def updateState(type_service, service_id, state):
    service_map = {
        "rds": RDSService,
        "host": HostService,
        "lb": LoadBalancer
    }
    service_class = service_map.get(type_service)
    if service_class:
        service = service_class.query.get(service_id)
        if service:
            service.state = state
            db.session.commit()
            return True
    return False

# if __name__ == "__main__":
#     from config import app
#     with app.app_context():
#         print(get_last_id_rds_service())
