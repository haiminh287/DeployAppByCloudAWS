import hashlib
from models import User,Block,HostService,RDSService
from config import db
from flask_login import current_user

def auth_user(username, password, role=None):
    password = str(hashlib.md5(password.encode('utf-8')).hexdigest())

    u = User.query.filter(User.username.__eq__(username),
                          User.password.__eq__(password))
    if role:
        u = u.filter(User.user_role.__eq__(role))
    print("user",u.first())
    return u.first()


def get_user_by_id(id):
    return User.query.get(id)


def create_block():
    block = Block(user_id = current_user.id)
    db.session.add(block)
    db.session.commit()
    return block


def get_blocks():
    return Block.query.all()


def create_host_service(url_github, text_script_run, type_ec2, block_id,vm_type,load_balancer_counter):  
    host_service = HostService(url_github=url_github, text_script_run=text_script_run, type_ec2=type_ec2, block_id=block_id,vm_type=vm_type,load_balancer_counter=load_balancer_counter)
    db.session.add(host_service)
    db.session.commit()
    return host_service

def create_rds_service(database_name,username , password, type_database ,block_id):  
    rds_service = RDSService(database_name=database_name, username=username, password=password, type_database=type_database, block_id=block_id)
    db.session.add(rds_service)
    db.session.commit()
    return rds_service

def get_host_service_by_block_id(block_id):
    return HostService.query.filter(HostService.block_id.__eq__(block_id)).first()

def get_rds_service_by_block_id(block_id):
    return RDSService.query.filter(RDSService.block_id.__eq__(block_id)).first()