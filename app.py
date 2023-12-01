from flask import Flask, render_template, request, session, redirect, url_for
import mysql.connector

app = Flask(__name__)
app.secret_key = 'carlos18'
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.config['CACHE_TYPE'] = 'null'


# Configuración de la base de datos
db_config = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': 'carlos18',
    'database': 'seguiorden',
}

# Crear conexión a la base de datos
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Ruta principal
@app.route('/')
def index():
    # Ejemplo de consulta a la base de datos
    cursor.execute('SELECT * FROM usuarios')
    data = cursor.fetchall()
    return render_template('index.html', data=data)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        usuario = request.form['usuario']
        password = request.form['password']
        cursor.execute("select id, usuario, password, apellidos, nombre from usuarios where usuario = %s and password = %s", (usuario, password))

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
            return redirect(url_for('inicio_usuario'))

    return render_template('login.html', error=error if 'error' in locals() else None)

@app.route('/inicio_usuario')
def inicio_usuario():
    if 'usuario' in session:
        usuario = session['usuario']
        apellidos = session['apellidos']
        return render_template('inicio.html', usuario=usuario, apellidos=apellidos)
    else:
        return redirect(url_for('login'))

@app.route('/entregas')
def entregas():
    if 'usuario' in session:
        usuario = session['usuario']
        apellidos = session['apellidos']
        return render_template('entregas.html', usuario=usuario, apellidos=apellidos)
    else:
        return redirect(url_for('login'))

@app.route('/cerrar')
def cerrar():
    session.pop('id', None)
    session.pop('usuario', None)
    session.pop('password', None)
    session.pop('apellidos', None)
    session.pop('nombre', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
