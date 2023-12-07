from flask import Flask, jsonify, abort
from flask_cors import CORS
from DBConect import ConectToPostgreSQL
import json

servico = Flask("auth")
CORS(servico)

@servico.get("/info")
def get_info():
    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    conexao.close_conection()
    return jsonify(
        descricao = "Serviço de autenticação. {}".format(conexao.status_conection()),
        versao = "1.0"
    )

@servico.get("/login/<string:email>/<string:senha>")
def login(email,senha ):
    sql = f"SELECT * FROM users WHERE UPPER(email) = UPPER('{email}') AND UPPER(senha) = UPPER('{senha}')"
    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    total = len(resposta)
    conexao.close_conection()
    if total == 0:
            # Se a resposta estiver vazia, retorne uma resposta 404 Not Found
            abort(404, description="Nenhum usuário encontrado para o email e senha fornecidos.")
    flattened_results = [dict(row) for row in resposta]
    return json.dumps(flattened_results, default=str) 


if __name__ == "__main__":
    servico.run(host="0.0.0.0",port=5001, debug=True)