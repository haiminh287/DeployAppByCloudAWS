from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from urllib.parse import quote
import secrets
from datetime import timedelta
from flask_login import LoginManager

app = Flask(__name__)
app.secret_key = 'HJGGHD*^&R$YGFGHDYTRER&*TRTYCHG^R&^T'
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:%s@localhost/cloudcomputingdb" % quote('Marcus0@')
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
app.config["PAGE_SIZE"] = 8

db = SQLAlchemy(app)
login = LoginManager(app)

login.login_view = '/login'  # URL của trang đăng nhập
login.login_message = "Bạn cần đăng nhập để truy cập trang này."  # Thông báo tùy chỉnh (nếu cần)
