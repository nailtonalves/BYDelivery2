import unittest
import urllib.request
import json

URL_API = "http://localhost:5003"
SERVICO_INFO = "info"
SERVICO_TOTAL_FATURAMENTO = "gettotalfaturamento"
SERVICO_FINALIZAR_ENTREGA= "finalizarentrega"
SERVICO_ENTREGA= "getentrega"

class TesteEntregas(unittest.TestCase):

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
        
    def testar_02_totalizar_faturamento(self):
        idUsuario = 1
        resposta = self.acessar(f"{URL_API}/{SERVICO_TOTAL_FATURAMENTO}/{idUsuario}")
        dados = json.loads(resposta)
        # self.assertEqual(dados['total_faturamento'], None)
        self.assertEqual(dados['total_faturamento'], "10.56")
        
    def testar_03_entrega(self):
        idUltimaEntrega = 1
        resposta = self.acessar(f"{URL_API}/{SERVICO_ENTREGA}/{idUltimaEntrega}")
        dados = json.loads(resposta)
        self.assertEqual(len(dados), 1)
        # self.assertEqual(dados[0]['id'], 3)