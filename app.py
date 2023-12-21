'''
---------------------------------------------------------------------------------------------------------------------------
Creacion e implementacion de una API para el area de Planeacion y logistica.
Troquelados Modulares S.A de C.V, San Miguel de La Victoria, Estado de Mexico, Mexico
---------------------------------------------------------------------------------------------------------------------------
* Autor: Arce Hernandez Carlos Eduardo
* Version: 1.0
* Version de Python: 3.11.6
* Virtualenv: venv
* SO: Arch Linux
* Kernel: 6.6.4-arch1-1
* GitHub: https://github.com/CarlosArce-tes/TMO-Area-Logistica.git 
* Correo Electronico: arcecarlos1c@gmail.com 

---------------------------------------------------------------------------------------------------------------------------
'''



import os
from flask import Flask, render_template, request, session, redirect, url_for, flash
import mysql.connector
from werkzeug.utils import secure_filename
from flask_bootstrap import Bootstrap
from flask_mail import Mail, Message
from flask_cors import CORS
#Inicializacion de la aplicacion de Flask
app = Flask(__name__)
CORS(app, origins="*")
#Creacion del objeto bootstrap para la aplicacion de estilos
bootstrap  = Bootstrap(app)
#Configuracion del servidor de correos
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
#Puerto por default que utiliza el servidor de correos
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'arcecarlos1c@gmail.com'
#Clave para el envio de correos, se obtien en la autenticacion por dos pasos, sustituirla por la clae correspondiente al correo electronico de la empresa o el usuario administrador
app.config['MAIL_PASSWORD'] = 'umecsvrpezpqkqbm'
#inicializacion del servidor de correos de gmail, se puede configurar cualquier servidor sea GMail, Hotmail
mail = Mail(app)
#Clave secreta de la aplicaicon, clave de seguridad que solo eladministrador debe conocer
app.secret_key = 'carlos18'
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['CACHE_TYPE'] = 'null'
#Configuracion del directorio de almacenamiento de archivos
UPLOAD_FOLDER = 'static'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
# Configuración de la base de datos
db_config = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': 'carlos18',
    'database': 'seguiorden',
}

#Funcion de conexion a la base de datos MySQL
def get_db_connection():
    return mysql.connector.connect(**db_config)
#Cierre de conexion de la base de datos MySQL
def close_db_connection(conn, cursor):
    cursor.close()
    conn.close()

# Ruta principal
@app.route('/index')
def index():
    #Creacion de objetos para la conexion a la base de datos en esta tura
    conn = get_db_connection()
    cursor = conn.cursor()

    # Ejemplo de consulta a la base de datos
    cursor.execute('SELECT * FROM usuarios')
    data = cursor.fetchall()
    #Cierre de la conexion a la base de datos
    close_db_connection(conn, cursor)

    return render_template('index.html')

'''
En el login, se hacen peticiones, get y post necesarios para la autenticacion
'''
@app.route('/login', methods=['GET', 'POST'])
def login():
    #Conexion a la Base de Datos 
    conn = get_db_connection()
    cursor = conn.cursor()
    #Se llama a la funcio index, la encargada de hacer la consulta de usuarios para la validacion y login en esta ruta
    index()  # Llamar a la función index para crear conexión y cursor

    error = None

    if request.method == 'POST':
        #Peticion de las claves de acceso del usuario para poder ingresar a la pagina principal
        usuario = request.form['usuario']
        password = request.form['password']
        #Seleccion de los datos del usuario necesarios para esta ruta, e este caso la informacion del usuario que se presentara o para las operaciones dentro de la plataforma, se pasa 
        #como parametros el usuario y la contraseña del usuario
        cursor.execute("SELECT id, usuario, password, apellidos, nombre FROM usuarios WHERE usuario = %s AND password = %s", (usuario, password))
        #Se condiciona que solo se devuelva un resultado de la consulta
        usuario_data = cursor.fetchone()
        #Si se obtuvo un resultado igual a la consulta se alamacena en la variable usuario_data, se condiciona si son existentes en la base de datos, en caso de que si procede al almacenamiento de los datos del usuario resultante de las consultas
        if usuario_data is None:
            #Credenciales invalidas
            error = 'Usuario o contraseña incorrectos'
            print(error)
        elif usuario_data:
            #Almacenamiento de la informacion del usuario en varibles que se podran utilizar durante la sesion
            session['id'] = usuario_data[0]
            session['usuario'] = usuario_data[1]
            session['password'] = usuario_data[2]
            session['apellidos'] = usuario_data[3]
            session['nombre'] = usuario_data[4]
            close_db_connection(conn, cursor)
            '''
            correo = 'yanetalmazan0512@gmail.com'
            from_email = 'arcecarlos1c@gmail.com'
            to_email= correo
            subject= ' Iniciaste Sesion en La aplicacion de la tienda'
            message= 'Nuevo inicio de Sesion en un Dispositivo, Manten cuidado con tus sesiones para evitar problemas en la plataforma'
            msg= Message(subject=subject, sender=from_email, recipients=[to_email], body=message)
            try:
                mail.send(msg)
                print('Correo enviado')
            except Exception as e:
                print('Correo no enviado')
                
            '''
            #Redireccion a la pagina de inicio
            return redirect(url_for('inicio_usuario'))
    close_db_connection(conn, cursor)

    return render_template('login.html', error=error)


@app.route('/inicio_usuario')
def inicio_usuario():
    if 'usuario' in session:
        usuario = session['usuario']
        apellidos = session['apellidos']
        nombre = session['nombre']
        return render_template('inicio.html', usuario=usuario, apellidos=apellidos, nombre=nombre)
    else:
        return redirect(url_for('login'))


@app.route('/entregas')
def entregas():
    conn = get_db_connection()
    cursor = conn.cursor()

    if 'usuario' in session:
        usuario = session['usuario']
        apellidos = session['apellidos']
        close_db_connection(conn, cursor)
        return render_template('entregas.html', usuario=usuario, apellidos=apellidos)
    else:
        close_db_connection(conn, cursor)
        return redirect(url_for('login'))




@app.route('/pagos')
def pagos():
    conn = get_db_connection()
    cursor = conn.cursor()

    if 'usuario' in session:
        usuario = session['usuario']
        apellidos = session['apellidos']
        cursor.execute('SELECT * FROM Pagos')
        pagos = cursor.fetchall()
        close_db_connection(conn, cursor)
        return render_template('pagos.html', usuario=usuario, pagos=pagos)
    else:
        close_db_connection(conn, cursor)
        return redirect(url_for('login'))

@app.route('/agregarPago', methods=['POST', 'GET'])
def agregarPago():
    conn = get_db_connection()
    cursor = conn.cursor()

    if 'usuario' in session:
        if request.method == 'POST':
            archivo_pdf = request.files['file']
            estado = request.form['estado']
            estadoint = int(estado)

            if archivo_pdf:
                nombre_archivo = secure_filename(archivo_pdf.filename)
                archivo_pdf.save(os.path.join(app.config['UPLOAD_FOLDER'], nombre_archivo))
                
                # Corregir la consulta SQL y usar una tupla para los valores
                cursor.execute('INSERT INTO Pagos (NombreArchivo, Estatus) VALUES (%s, %s)', (nombre_archivo, estadoint))
                conn.commit()  # Guardar los cambios en la base de datos
                flash('El pago se agregó correctamente.', 'success')
        close_db_connection(conn, cursor)
    else: 
        return redirect(url_for('login'))
    return render_template('agregarPago.html' )
#Ruta de visualizacion de archivos
@app.route('/verarchivos', methods=['GET', 'POST'])
def verarchivos():
    static_dir = 'static'
    all_files = os.listdir(static_dir)

    # Manejar la búsqueda si se envió un formulario POST
    if request.method == 'POST':
        search_term = request.form.get('search', '').lower()
        if search_term:
            files = [file for file in all_files if search_term in file.lower()]
        else:
            files = all_files
    else:
        files = all_files

    return render_template('verarchivos.html', files=files, static_dir=static_dir)


@app.route('/eliminar_archivo/<filename>', methods=['GET', 'POST'])
def eliminar_archivo(filename):
    static_dir = 'static'
    file_path = os.path.join(static_dir, filename)
    if os.path.exists(file_path):
        os.remove(file_path)
    return redirect(url_for('verarchivos'))

@app.route('/cerrar')
def cerrar():
    session.pop('id', None)
    session.pop('usuario', None)
    session.pop('password', None)
    session.pop('apellidos', None)
    session.pop('nombre', None)
    
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
    