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

@servico.get("/gettotalfaturamento/<int:idUsuario>")
def get_total_faturamento(idUsuario=0):
    sql = ("SELECT SUM(d.valor) AS total_faturamento FROM deliveries d "
        f"INNER JOIN users u ON u.id = {idUsuario} "
        f"WHERE d.status = 'FINALIZADA' AND d.id_usuario = {idUsuario}")
    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    total = len(resposta)
    conexao.close_conection()
    return jsonify(total_faturamento = resposta[0]['total_faturamento'])

@servico.get("/finalizarentrega/<int:idUsuario>/<int:idEntrega>")
def finalizar_entrega(idUsuario=0, idEntrega=0):
    sql = ("UPDATE deliveries "
            f"SET status = 'FINALIZADA', id_usuario = {idUsuario}, data_entrega = CURRENT_TIMESTAMP "
            f"WHERE id = {idEntrega} ")   
    try:        
        conexao = ConectToPostgreSQL()
        conexao.get_conection()
        cursor = conexao.conection.cursor()
        cursor.execute(sql)
        id_entrega = cursor.rowcount
        conexao.conection.commit()
        conexao.close_conection()
        return jsonify({"message": "Entrega finalizada gravado com sucesso!", "id_review": id_entrega}), 201
    except Exception as e:
        return jsonify({"erro": str(e)}), 500


@servico.get("/iniciarentrega/<int:idUsuario>/<int:idEntrega>")
def iniciar_entrega(idUsuario=0, idEntrega=0):
    sql = ("UPDATE deliveries "
            f"SET status = 'INICIADA', id_usuario = {idUsuario} "
            f"WHERE id = {idEntrega} ")   
    try:        
        conexao = ConectToPostgreSQL()
        conexao.get_conection()
        cursor = conexao.conection.cursor()
        cursor.execute(sql)
        id_entrega = cursor.rowcount
        conexao.conection.commit()
        conexao.close_conection()
        return jsonify({"message": "Entrega iniciada com sucesso!", "id_review": id_entrega}), 201
    except Exception as e:
        return jsonify({"erro": str(e)}), 500

@servico.get("/getentrega/<int:idEntrega>")
def get_entrega(idEntrega=0):
    sql = ("SELECT d.id, d.id_estabelecimento, " 
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