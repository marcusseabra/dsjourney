import pdfplumber
import os
import re
import datetime

# https://github.com/jsvine/pdfplumber/blob/stable/examples/notebooks/extract-table-nics.ipynb
# https://github.com/jsvine/pdfplumber#extracting-
# Redis: redis-12269.c257.us-east-1-3.ec2.cloud.redislabs.com:12269
# Redis: Default User
# Redis: Password Bp20u9kKXX8lx1Ng4RJrfvKn0JiSpZCX

DATADIR = '/home/seabra/Documentos/IR_2021/Notas_Negociacao/'
DATADIR_DESTINO = '/home/seabra/Documentos/IR_2021/output/'


def leitura_notas_negociacao():
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
                    data_nota_negociacao = None
                    data_nota_negociacao = obterDataNotaNegociacao(linhas[len(linhas) - 1])
                    if data_nota_negociacao is None:
                        data_nota_negociacao = obterDataNotaNegociacao(linhas[len(linhas) - 2])
                i = i + 1
                if linhas[0] == "1-BOVESPA":
                    linhas.append(data_nota_negociacao)
                    lista_final.append(linhas)

        print("\tLeitura finalizada")

    for item_negociacao in lista_final:
        print(item_negociacao)


def tratar_registros_negociacao(registro_negociacao):
    resposta = {"ativo": None,
                "ticker": None,
                "quantidade": None,
                "valor_unitario": None,
                "valor_negociado": None,
                "data_negociacao": None,
                "is_compra": True}

    # O ativo negociado pode estar no quarto ou no quinto ou no sexto item
    # do registro de negociação

    # Tratamento do último item correspondendo à data de negociação
    resposta['data_negociacao'] = registro_negociacao[len(registro_negociacao) - 1]
    resposta['data_negociacao'] = registro_negociacao[len(registro_negociacao) - 1]
    if registro_negociacao[1] == "C VIST":
        registro_negociacao[1] = "C"
        registro_negociacao[2] = "VISTA"
    if registro_negociacao[3] == "":
        registro_negociacao[3] = registro_negociacao[4]

    return registro_negociacao


def consultarAtivo(nomeAtivoNotaNegociacao):
    resposta = None
    if (nomeAtivoNotaNegociacao == "ENERGIAS BR"
        or nomeAtivoNotaNegociacao == "ENERGIAS B"):
        resposta = "Energias do Brasil"
    elif nomeAtivoNotaNegociacao == "ENGIE BRASI":
        resposta = "Engie Brasil"

    return resposta

def obterDataNotaNegociacao(texto):
    # Busca no texto padrão de escrita de dia/mês
    dia_mes = re.search(r'\d{2}/\d{2}', texto)

    if dia_mes is None:
        return None

    return dia_mes.group()


leitura_notas_negociacao()
# obterDataNotaNegociacao("Texto 03/07/2020 Novo Texto")
