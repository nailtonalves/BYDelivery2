import unittest
from teste_login import *
from teste_comentarios import *
from teste_entregas import *

if __name__ == "__main__":
    carregador = unittest.TestLoader()
    testes = unittest.TestSuite()

    testes.addTest(carregador.loadTestsFromTestCase(TesteLogin))
    testes.addTest(carregador.loadTestsFromTestCase(TesteComentarios))
    testes.addTest(carregador.loadTestsFromTestCase(TesteEntregas))

    executor = unittest.TextTestRunner()
    executor.run(testes)