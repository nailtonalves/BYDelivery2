import unittest
import urllib.request
import json

URL_API = "http://localhost:5001"
SERVICO_INFO = "info"
SERVICO_LOGIN = "login"

class TesteLogin(unittest.TestCase):

    def acessar(self, url):
        resposta = urllib.request.urlopen(url)
        dados = resposta.read()
        return dados.decode("utf-8")
    
    def testar_01_info(self):
        resposta = self.acessar(f"{URL_API}/{SERVICO_INFO}")
        dados = json.loads(resposta)
        self.assertEqual(dados['versao'], "1.0")

    def testar_02_info(self):
        resposta = self.acessar(f"{URL_API}/{SERVICO_LOGIN}/alice%40email.com/8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92")
        dados = json.loads(resposta)

        self.assertEqual(dados[0]['id'], 1)