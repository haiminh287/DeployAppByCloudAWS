
from config import app, db
from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey, DateTime, Enum, Text,LargeBinary
from flask_login import UserMixin
from enum import Enum as RoleEnum
from datetime import datetime as dt
from sqlalchemy_utils import EmailType
import hashlib
class UserRole(RoleEnum):
    ADMIN = 1
    USER = 2

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(128), nullable=False)
    active = Column(Boolean, default=True)
    username = Column(String(128), unique=True, nullable=False)
    password = Column(String(128), nullable=False)
    created_at = Column(DateTime,default=dt.now())
    email = Column(EmailType, unique=True, nullable=True)
    user_role = Column(Enum(UserRole), default=UserRole.USER)
    blocks = db.relationship('Block', backref='user', lazy=True)  # Quan hệ một-nhiều với Block


class BaseModel(db.Model):
    __abstract__ = True
    created_at = Column(DateTime, default=dt.now())
    updated_at = Column(DateTime, default=dt.now(), onupdate=dt.now())

class Block(BaseModel):
    __tablename__ = 'blocks'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)

class Service(BaseModel):
    __abstract__ = True
    __tablename__ = 'services'
    id = Column(Integer, primary_key=True, autoincrement=True)
    block_id = Column(Integer, ForeignKey('blocks.id'), nullable=False)
    service_id = Column(String(256), nullable=True)

class VMTypeEnum(RoleEnum):
    UBUNTU = "ubuntu"
    WINDOW = "window"
    LINUX = "linux"

class EC2Type(RoleEnum):
    T2_MICRO = "t2.micro"
    T2_SMALL = "t2.small"
    T2_MEDIUM = "t2.medium"



class TypeDatabaseEnum(RoleEnum):
    MYSQL = "mysql"
    MS_SQL = "ms_sql"
class HostService(Service):
    __tablename__ = 'host_services'
    id = Column(Integer, primary_key=True, autoincrement=True)
    url_github = Column(String(256), nullable=False)
    text_script_run = Column(Text, nullable=False)
    type_ec2 = Column(Enum(EC2Type), default=EC2Type.T2_MICRO)
    vm_type = Column(Enum(VMTypeEnum), default=VMTypeEnum.UBUNTU)
    key_pair = Column(LargeBinary, nullable=True)
    load_balancer_counter = Column(Integer, nullable=True)
    url_web_load_balancer = Column(String(256), nullable=True)
    public_ip = Column(String(256), nullable=True)

class RDSService(Service):
    __tablename__ = 'rds_services'
    id = Column(Integer, primary_key=True, autoincrement=True)
    url_host = Column(String(256), nullable=True)
    port = Column(Integer, nullable=True)
    username = Column(String(128), nullable=True)
    password = Column(String(128), nullable=True)
    database_name = Column(String(128), nullable=True)
    type_database = Column(Enum(TypeDatabaseEnum), default=TypeDatabaseEnum.MYSQL)


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        u = User(name='user', username='user', email='user2k4@gmail.com',password=str(hashlib.md5('123456'.encode('utf-8')).hexdigest()), user_role=UserRole.USER)
        db.session.add(u)
        ad = User(name='admin', username='admin', email='admin224@gmail.com',password=str(hashlib.md5('123456'.encode('utf-8')).hexdigest()), user_role=UserRole.ADMIN)
        db.session.add(ad)
        db.session.commit()