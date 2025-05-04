from config import app,login
from flask import render_template,request, jsonify, session, redirect,url_for
import dao
from flask_login import login_user, logout_user,login_required
from models import EC2Type,VMTypeEnum,TypeDatabaseEnum

@app.route('/')
def index() ->str:
    return render_template("index.html", blocks=dao.get_blocks())


@app.route("/login", methods=['get', 'post'])
def login_view():
    if request.method.__eq__('POST'):
        username = request.form.get('username')
        password = request.form.get('password')
        user = dao.auth_user(username=username, password=password)
        print("USER:", user)
        if user:
            login_user(user=user,remember=True)

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
    return jsonify({"block_id":block.id,"created_at":block.created_at,"updated_at":block.updated_at}) 


@app.route('/blocks/<int:block_id>', methods=['GET'])
@login_required
def get_block(block_id):
    host_service = dao.get_host_service_by_block_id(block_id)
    rds_service= dao.get_rds_service_by_block_id(block_id)
        
    return render_template('block.html', block_id=block_id,rds_service=rds_service,host_service=host_service)


@app.route('/blocks/<int:block_id>/services/<int:service_id>', methods=['GET'])
@login_required
def get_service(block_id,service_id):
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


@app.route('/host-services', methods=['POST'])
def create_host_service():
    if request.method.__eq__('POST'):
        url_github = request.form.get('url_github')
        text_script_run = request.form.get('text_script_run')
        block_id = request.form.get('block_id')
        ec2_type = request.form.get('ec2_type')
        vm_type = request.form.get('vm_type')
        ec2_type = EC2Type(ec2_type)
        vm_type = VMTypeEnum(vm_type)
        load_balancer_counter = request.form.get('load_balancer_count')
        dao.create_host_service(url_github=url_github, text_script_run=text_script_run, type_ec2=ec2_type,block_id=block_id,vm_type=vm_type,load_balancer_counter=load_balancer_counter)  # Tạo dịch vụ mới
        return redirect(f'/blocks/{block_id}')
    

@app.route('/rds-services', methods=['POST'])
def create_rds_service():
    if request.method.__eq__('POST'):
        username = request.form.get('username')
        password = request.form.get('password')
        block_id = request.form.get('block_id')
        database_name = request.form.get('database_name')
        type_database = request.form.get('type_database')
        type_database = TypeDatabaseEnum(type_database)

        dao.create_rds_service(username=username, password=password, database_name=database_name, type_database=type_database, block_id=block_id)
        return redirect(f'/blocks/{block_id}')
    

@login.user_loader
def load_user(user_id):
    return dao.get_user_by_id(user_id)


if __name__=='__main__':
    import admin
    app.run(debug=True)