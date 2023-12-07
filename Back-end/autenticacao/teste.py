import psycopg2
from psycopg2 import extras
from typing import Union


        # Substitua os valores com suas próprias configurações
        # host = 'banco-postgresql'
host = 'localhost'
database = 'b_y_delivery'
user = 'postgres'
password = 'postgres'
port = 5432
conection: Union[psycopg2.extensions.connection, None] = None
status = "Não Conectado."

def get_conection():
    global conection, status
    try:
        conection = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password,
            port=port,
            cursor_factory=psycopg2.extras.DictCursor
        )        
        status = "Conectado!"
        print("Conexão estabelecida com sucesso!")

    except Exception as e:
        print(f"Erro ao conectar ao PostgreSQL: {e}")

def close_conection():
    global conection, status
    if conection:
        conection.close()
        status = "Não Conectado."
        print("Conexão fechada.")

def status_conection() -> str:    
    return str(status)

def execute_query( query):
    cursor = conection.cursor(cursor_factory=extras.DictCursor)
    cursor.execute(query)
    return cursor.fetchall()

if __name__ == "__main__":
    get_conection()
    print(status_conection())
