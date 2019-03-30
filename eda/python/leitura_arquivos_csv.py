import csv
import os
import re

DATADIR = '/home/seabra/dev/udacity/modulo-1/util/entrada'
DATADIR_DESTINO = '/home/seabra/dev/udacity/modulo-1/util/saida'
PATH_ARQUIVO_BD = '/home/seabra/dev/udacity/modulo-1/util'

def leitura_arquivos():
    arquivo_entrada = os.path.join(DATADIR, "RM 20330 - Credito Concedido e Calculado.csv")
    linhas_analise = []
    #cabecalho = []

    with open(arquivo_entrada) as arq:
        reader = csv.DictReader(arq, delimiter=';')
        cabecalho = reader.__next__()
        print(cabecalho)
        for linha in reader:
            if linha['FALHA'] == "SIM":
                linhas_analise.append(str(linha))

    arq.close()

    arquivoFinal = open(os.path.join(DATADIR_DESTINO, "RM 20330 - Credito Concedido Excesso.csv"), 'w')
    arquivoFinal.writelines(linhas_analise)
    arquivoFinal.close()

    print("FINALIZADO")

leitura_arquivos()
