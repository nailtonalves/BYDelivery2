import psycopg2
from psycopg2 import extras
from typing import Union

class ConectToPostgreSQL:
    

    def __init__(self):
        # Substitua os valores com suas próprias configurações
        # self.host = 'banco-postgresql'
        self.ambiente = "DOCKER"
        self.host = ''
        self.database = 'b_y_delivery'
        self.user = 'postgres'
        self.password = 'postgres'
        self.port = 5432
        self.conection: Union[psycopg2.extensions.connection, None] = None
        self.status = "Não Conectado."

    def get_conection(self):
        try:
            if(self.ambiente == "LOCAL"):
                self.host = 'localhost'
            else:
                self.host = 'banco-postgresql'
            
            self.conection = psycopg2.connect(
                host=self.host,
                database=self.database,
                user=self.user,
                password=self.password,
                port=self.port,
                cursor_factory=psycopg2.extras.DictCursor
            )        
            self.status = "Conectado!"
            print("Conexão estabelecida com sucesso!")

        except Exception as e:
            print(f"Erro ao conectar ao PostgreSQL: {e}")

    def close_conection(self):
        if self.conection:
            self.conection.close()
            self.status = "Não Conectado."
            print("Conexão fechada.")

    def status_conection(self) -> str:
        
        return str(self.status)

    def execute_query(self, query):
        cursor = self.conection.cursor(cursor_factory=extras.DictCursor)
        cursor.execute(query)
        return cursor.fetchall()

