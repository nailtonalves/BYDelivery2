from flask import Flask, jsonify, abort, request
from flask_cors import CORS
from DBConect import ConectToPostgreSQL
import json

servico = Flask("review")
CORS(servico)

@servico.get("/info")
def get_info():
    return jsonify(
        descricao = "Serviço de Comentários.",
        versao = "1.0"
    )

@servico.get("/getall")
def get_all():
    sql = "SELECT * FROM reviews"
    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    total = len(resposta)
    conexao.close_conection()
    if total == 0:
        # Se a resposta estiver vazia, retorne uma resposta 404 Not Found
        abort(404, description="Nenhum comentário encontrado.")
    flattened_results = [dict(row) for row in resposta]
    return json.dumps(flattened_results, default=str) 

@servico.get("/getalluser/<int:idUsuario>")
def get_all_user(idUsuario):
    sql = f"SELECT * FROM reviews WHERE idUsuario = {idUsuario}"
    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    total = len(resposta)
    conexao.close_conection()
    if total == 0:
        # Se a resposta estiver vazia, retorne uma resposta 404 Not Found
        abort(404, description="O usuário não fez nenhum comnetário.")
    flattened_results = [dict(row) for row in resposta]
    return json.dumps(flattened_results, default=str) 

@servico.route("/getallreviewusers/<int:page>/<int:page_size>")
def get_all_reviews_user(page=1, page_size=10):
    # Calcule o índice de início com base na página e no tamanho da página
    start_index = (page - 1) * page_size

    sql = (
        "SELECT r.id, u.id as id_usuario, u.avatar, u.nome as usuario, r.rating, r.comentario, "
        "TO_CHAR(r.data, 'DD/MM/YYYY') as data "
        "FROM reviews r "
        "INNER JOIN users u ON r.idUsuario = u.id "
        f"ORDER BY r.id DESC LIMIT {page_size} OFFSET {start_index}"
    )

    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    total = len(resposta)
    conexao.close_conection()

    if total == 0:
        # Se a resposta estiver vazia, retorne uma resposta 404 Not Found
        abort(404, description="Nenhum comentário encontrado.")

    flattened_results = [dict(row) for row in resposta]
    return json.dumps(flattened_results, default=str)

@servico.route("/gettotalreviews")
def get_total_reviews():
    sql = (
        "SELECT COUNT(1) as total "
        "FROM reviews r "
    )
    # Criar uma instância da classe
    conexao = ConectToPostgreSQL()
    conexao.get_conection()
    resposta = conexao.execute_query(sql)
    conexao.close_conection()
    return jsonify(resposta[0]['total'])

@servico.post("/insertreview")
def insert_review():
    try:
        # Obter dados da solicitação POST
        comentario = request.json
        # Criar uma instância da classe
        conexao = ConectToPostgreSQL()
        conexao.get_conection()
        # Executar o comando SQL de inserção
        cursor = conexao.conection.cursor()
        cursor.execute(
            "INSERT INTO reviews (idUsuario, rating, comentario) VALUES (%s, %s, %s) RETURNING id",
            (comentario["id_usuario"], comentario["rating"], comentario.get("comentario", None))
        )
        # Obter o ID do review inserido
        id_review = cursor.fetchone()[0]
        # Confirmar a transação e fechar a conexão
        conexao.conection.commit()
        conexao.close_conection()
        return jsonify({"message": "Comentário gravado com sucesso!", "id_review": id_review}), 201
    except Exception as e:
        return jsonify({"erro": str(e)}), 500


if __name__ == "__main__":
    servico.run(host="0.0.0.0",port=5002, debug=True)