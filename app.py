import os
from flask import Flask, render_template, request, session, redirect, url_for
import mysql.connector
from werkzeug.utils import secure_filename


app = Flask(__name__)
app.secret_key = 'carlos18'
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['CACHE_TYPE'] = 'null'
UPLOAD_FOLDER = 'static'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
# Configuración de la base de datos
db_config = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': 'carlos18',
    'database': 'seguiorden',
}


def get_db_connection():
    return mysql.connector.connect(**db_config)

def close_db_connection(conn, cursor):
    cursor.close()
    conn.close()

# Ruta principal
@app.route('/index')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Ejemplo de consulta a la base de datos
    cursor.execute('SELECT * FROM usuarios')
    data = cursor.fetchall()

    close_db_connection(conn, cursor)

    return render_template('index.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    conn = get_db_connection()
    cursor = conn.cursor()

    index()  # Llamar a la función index para crear conexión y cursor

    error = None

    if request.method == 'POST':
        usuario = request.form['usuario']
        password = request.form['password']
        cursor.execute("SELECT id, usuario, password, apellidos, nombre FROM usuarios WHERE usuario = %s AND password = %s", (usuario, password))

        usuario_data = cursor.fetchone()
        if usuario_data is None:
            error = 'Usuario o contraseña incorrectos'
            print(error)
        elif usuario_data:
            session['id'] = usuario_data[0]
            session['usuario'] = usuario_data[1]
            session['password'] = usuario_data[2]
            session['apellidos'] = usuario_data[3]
            session['nombre'] = usuario_data[4]
            close_db_connection(conn, cursor)
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


@app.route('/cerrar')
def cerrar():
    session.pop('id', None)
    session.pop('usuario', None)
    session.pop('password', None)
    session.pop('apellidos', None)
    session.pop('nombre', None)
    return redirect(url_for('index'))


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
    close_db_connection(conn, cursor)
    return render_template('agregarPago.html')
    
if __name__ == '__main__':
    app.run(debug=True)
