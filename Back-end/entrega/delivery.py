from flask import Flask, jsonify
from flask_cors import CORS
from DBConect import ConectToPostgreSQL
import json

servico = Flask("delivery")
CORS(servico)

@servico.get("/info")
def get_info():
    return jsonify(
        descricao = "Serviço de Entregas.",
        versao = "1.0"
    )

@servico.get("/getentrega/<int:idEntrega>")
def get_entrega(idEntrega=0):
    sql = ("SELECT d.id_estabelecimento, " 
    "c.endereco AS estabelecimento_endereco, c.latitude AS estabelecimento_latitude, c.longitude AS estabelecimento_longitude, "
    "d.nome_cliente, "
    "d.endereco AS cliente_endereco, d.latitude AS cliente_latitude, d.longitude AS cliente_longitude, "
    "d.data_criacao,  d.data_entrega, "
    "d.id_usuario, d.status, d.valor "
    "FROM deliveries d "
    "INNER JOIN companies c ON c.id = d.id_estabelecimento "
    f"WHERE d.status = 'PENDENTE' AND d.id > {idEntrega} LIMIT 1")

    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    total = len(resposta)
    conexao.close_conection()

    flattened_results = [dict(row) for row in resposta]
    return json.dumps(flattened_results, default=str) 

if __name__ == "__main__":
    servico.run(host="0.0.0.0",port=5003, debug=True)