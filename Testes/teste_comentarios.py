import unittest
import urllib.request
import json

URL_API = "http://localhost:5002"
SERVICO_INFO = "info"
SERVICO_LISTAR_COMENTARIOS = "getallreviewusers"
SERVICO_INSERIR_COMENTARIO = "insertreview"

TAMANHO_DA_PAGINA = 4

class TesteComentarios(unittest.TestCase):

    def acessar(self, url, method="GET", data=None, headers=None):        
        if data is not None:
            data = json.dumps(data).encode('utf-8')
        if headers is not None:
            request = urllib.request.Request(url, data=data, method=method, headers=headers)
        else:
            request = urllib.request.Request(url, data=data, method=method)        
        with urllib.request.urlopen(request) as resposta:
            dados = resposta.read()
            return dados.decode("utf-8")
    
    def testar_01_info(self):
        resposta = self.acessar(f"{URL_API}/{SERVICO_INFO}")
        dados = json.loads(resposta)
        self.assertEqual(dados['versao'], "1.0")

    def testar_02_lazy_loading(self):
        resposta = self.acessar(f"{URL_API}/{SERVICO_LISTAR_COMENTARIOS}/1/{TAMANHO_DA_PAGINA}")
        dados = json.loads(resposta)
        self.assertEqual(len(dados), TAMANHO_DA_PAGINA)
        # self.assertEqual(dados[0]['id'], 21)

    def testar_03_insert(self):
        headers = {"Content-Type": "application/json", "User-Agent": "python"}
        novo_comentario = {
            "id_usuario": 1,
	        "rating": 4.0,
	        "comentario": "Apenas mais um comentário de teste"
        }
        resposta = self.acessar(f"{URL_API}/{SERVICO_INSERIR_COMENTARIO}", method="POST", data=novo_comentario, headers=headers)
        dados = json.loads(resposta)        
        self.assertEqual(dados['message'], "Comentário gravado com sucesso!")
        # self.assertEqual(dados['id_review'], 1)