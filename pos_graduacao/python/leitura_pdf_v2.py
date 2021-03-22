import pdfplumber
import pandas as pd
import os

# https://github.com/jsvine/pdfplumber/blob/stable/examples/notebooks/extract-table-nics.ipynb
# https://github.com/jsvine/pdfplumber#extracting-tables

DATADIR = '/home/seabra/Documentos/IR_2021/Notas_Negociacao/'
DATADIR_DESTINO = '/home/seabra/Documentos/IR_2021/output/'

def leitura_arquivos_pdf():
    nomesArquivos = []
    lista_final = []
    # Lista arquivos de uma pasta
    for nome in os.listdir(DATADIR):
        nomesArquivos.append(nome)
    nomesArquivos.sort()

    table_settings = {
        "vertical_strategy": "text",
        "horizontal_strategy": "text",
        "intersection_x_tolerance": 15
    }

    for indice in range(len(nomesArquivos)):
        pdf = pdfplumber.open(os.path.join(DATADIR, nomesArquivos[indice]), password="027")

        print("Arquivo lido: " + str(nomesArquivos[indice]))

        # A propriedade pages é uma lista com o total de páginas do arquivo pdf lido
        print("\tNúmero de páginas do arquivo: " + str(len(pdf.pages)) + "\n")
        for pgn in range(len(pdf.pages)):
            leitura_pagina = pdf.pages[pgn]

            dados_tabela = leitura_pagina.extract_table(table_settings)
            i = 0
            for linhas in dados_tabela:
                if i == 2:
                    print(linhas)
                    data_nota_negociacao = obterDataNotaNegociacao(None, None)
                i = i + 1
                if linhas[0] == "1-BOVESPA":
                    linhas.append(data_nota_negociacao)
                    lista_final.append(linhas)

        print("\tLeitura finalizada")

    for item_negociacao in lista_final:
        print(item_negociacao)


def obterDataNotaNegociacao(info_1, info_2):

    return "07/11/1977"


leitura_arquivos_pdf()
