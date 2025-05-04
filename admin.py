from config import app, db
import dao
from flask import redirect
from flask_admin import Admin, BaseView, expose, AdminIndexView
from flask_admin.contrib.sqla import ModelView
from models import User, UserRole
from flask_login import current_user, logout_user


class MyAdminIndexView(AdminIndexView):
    @expose("/")
    def index(self):

        return self.render('admin/index.html')


admin = Admin(app=app, name='Cloud Computing', template_mode='bootstrap4', index_view=MyAdminIndexView())


class AdminAuthenticatedModelView(ModelView):
    def is_accessible(self):
        return current_user.is_authenticated and UserRole.ADMIN.name.__eq__(current_user.user_role.name)
    pass





class AuthendicatedBaseView(BaseView):
    def is_accessible(self):
        return current_user.is_authenticated


class LogoutView(AuthendicatedBaseView):
    @expose("/")
    def index(self):
        logout_user()
        return redirect('/admin')

admin.add_view(AdminAuthenticatedModelView(User, db.session))
