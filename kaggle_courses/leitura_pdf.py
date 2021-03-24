import pdfplumber
import os
import re
import datetime
import json

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

    # Configurações de tabela para leitura do pdfplumber
    table_settings = {
        "vertical_strategy": "text",
        "horizontal_strategy": "text",
        "intersection_x_tolerance": 15
    }

    for indice in range(len(nomesArquivos)):
        pdf = pdfplumber.open(os.path.join(DATADIR, nomesArquivos[indice]), password="027")

        print("Arquivo lido: " + str(nomesArquivos[indice]))

        # A propriedade pages é uma lista com o total de páginas do arquivo pdf lido
        print("\tNúmero de páginas do arquivo: " + str(len(pdf.pages)))
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

        print("\tLeitura do arquivo finalizada")

    for registro_arquivo_pdf in lista_final:
        print(registro_arquivo_pdf)

    print("########## Dados de negociação com falhas ##########")
    for registro_arquivo_pdf in lista_final:
        registro_negociacao = tratar_registros_negociacao(registro_arquivo_pdf)
        if registro_negociacao[3] is None:
            print(registro_arquivo_pdf)
            print(json.dumps(registro_negociacao, indent=4))


def tratar_registros_negociacao(registro_negociacao):
    resposta = {"ativo": None,
                "ticker": None,
                "quantidade": None,
                "valor_unitario": None,
                "valor_negociado": None,
                "data_negociacao": None,
                "is_compra": True}
    valor_negociado = 0

    # O ativo negociado pode estar no quarto ou no quinto ou no sexto item
    # do registro de negociação
    nomeAtivo = consultarNomeAtivo(registro_negociacao[3])
    if nomeAtivo is None:
        nomeAtivo = consultarNomeAtivo(registro_negociacao[4])
        if nomeAtivo is None:
            nomeAtivo = consultarNomeAtivo(registro_negociacao[5])
    resposta['ativo'] = nomeAtivo

    # O penúltimo item corresponde ao indicador de compra ou venda que, em alguns casos,
    # precisa ser corretamente tratado
    indicadorCompraVenda = resposta['data_negociacao'] = registro_negociacao[len(registro_negociacao) - 2]
    if indicadorCompraVenda == "C":
        resposta['is_compra'] = False
    elif indicadorCompraVenda == "D":
        resposta['is_compra'] = True
    else:
        # Promove tratamento do caso em que o registro de negociação não vem corretamente
        # separado e o indicador de compra e venda vem junto com o valor total negociado
        # para o item de negociação
        elementos = indicadorCompraVenda.split(" ")
        indicadorCompraVenda = elementos[1]
        if indicadorCompraVenda == "C":
            resposta['is_compra'] = False
        elif indicadorCompraVenda == "D":
            resposta['is_compra'] = True
        # Inicializa o valor total negociado já que ele está disponível no array 'elementos'
        valor_negociado = elementos[0]
        indice_valor_negociado = len(registro_negociacao) - 2

    # O valor total negociado é capturado no antepenúltimo ítem do registro de negociação
    if valor_negociado == 0:
        valor_negociado = registro_negociacao[len(registro_negociacao) - 3]
        indice_valor_negociado = len(registro_negociacao) - 3
    resposta['valor_negociado'] = float(str(valor_negociado).replace(",", "."))

    # Os itens do registro de negociação referentes aos valores unitários dos ativos e da
    # quantidade negociada é confuso. Será necessário obter os quatro últimos itens antes do
    # índice do valor negociado capturado para realizar operações envolvendo o valor negociado
    # e os quatro itens referenciados

    valores_itens_unitarios = [registro_negociacao[int(indice_valor_negociado) - 4],
                               registro_negociacao[int(indice_valor_negociado) - 3],
                               registro_negociacao[int(indice_valor_negociado) - 2],
                               registro_negociacao[int(indice_valor_negociado) - 1]]
    slider_valor_unitario = 3
    slider_quantidade = 2

    if valores_itens_unitarios[slider_quantidade] == "":
        if valores_itens_unitarios[slider_valor_unitario] != "":
            resposta['valor_unitario'] = float(str(valores_itens_unitarios[slider_valor_unitario]).replace(",", "."))
            resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        else:
            slider_valor_unitario = 2
            slider_quantidade = 1
            if valores_itens_unitarios[slider_valor_unitario] != "":
                resposta['valor_unitario'] = float(str(valores_itens_unitarios[slider_valor_unitario]).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
            else:
                slider_valor_unitario = 1
                resposta['valor_unitario'] = float(str(valores_itens_unitarios[slider_valor_unitario]).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
    else:
        if valores_itens_unitarios[slider_quantidade] == "0":
            resposta['valor_unitario'] = float(str(valores_itens_unitarios[slider_valor_unitario]).replace(",", "."))
            resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        if valores_itens_unitarios[slider_valor_unitario] == "":
            slider_valor_unitario = 2
            slider_quantidade = 1
            if valores_itens_unitarios[slider_quantidade] == "":
                resposta['valor_unitario'] = float(str(valores_itens_unitarios[slider_valor_unitario]).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        else:
            valor_unitario_temporario = (valores_itens_unitarios[slider_quantidade]
                                            + valores_itens_unitarios[slider_valor_unitario])
            quantidade_temporaria = valores_itens_unitarios[slider_quantidade]
            slider_quantidade = 1
            if valores_itens_unitarios[slider_quantidade] == "":
                resposta['valor_unitario'] = float(str(valor_unitario_temporario).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
            else:
                calculo_quantidade = round(resposta['valor_negociado']/float(str(valor_unitario_temporario).replace(",", ".")))
                if calculo_quantidade == int(valores_itens_unitarios[slider_quantidade]):
                    resposta['valor_unitario'] = float(str(valor_unitario_temporario).replace(",", "."))
                    resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])

    '''
    else:
        if valores_itens_unitarios[slider_valor_unitario] != "":
            valor_concatenado = valores_itens_unitarios[slider_quantidade]
                                    + valores_itens_unitarios[slider_valor_unitario]


    if valores_itens_unitarios[2] == "":
        if valores_itens_unitarios[1] == "":
            resposta['valor_unitario'] = float(str(valores_itens_unitarios[3]).replace(",", "."))
            resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        if valores_itens_unitarios[0] == "":
            resposta['valor_unitario'] = float(str(valores_itens_unitarios[3]).replace(",", "."))
            resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        if valores_itens_unitarios[3] == "":
            resposta['valor_unitario'] = float(str(valores_itens_unitarios[1]).replace(",", "."))
            resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        else:
            resposta['valor_unitario'] = float(str(valores_itens_unitarios[3]).replace(",", "."))
            resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
    else:
        if valores_itens_unitarios[1] == "":
            if valores_itens_unitarios[3] == "":
                resposta['valor_unitario'] = float(str(valores_itens_unitarios[2]).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
            elif valores_itens_unitarios[0] == "":
                resposta['valor_unitario'] = float(str(valores_itens_unitarios[3]).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        if valores_itens_unitarios[0] == "":
            if valores_itens_unitarios[3] == "":
                resposta['valor_unitario'] = float(str(valores_itens_unitarios[2]).replace(",", "."))
                resposta['quantidade'] = round(resposta['valor_negociado']/resposta['valor_unitario'])
        if valores_itens_unitarios[3] != "":
            teste_valor_unitario = valores_itens_unitarios[2] + valores_itens_unitarios[3]
    '''
    # Tratamento do último item correspondendo à data de negociação
    resposta['data_negociacao'] = registro_negociacao[len(registro_negociacao) - 1]

    return registro_negociacao


def consultarNomeAtivo(nomeAtivoNotaNegociacao):
    resposta = None

    if (nomeAtivoNotaNegociacao == "ENERGIAS BR"
        or nomeAtivoNotaNegociacao == "ENERGIAS B"):
        resposta = "Energias do Brasil"
    elif (nomeAtivoNotaNegociacao == "ENGIE BRASI"
          or nomeAtivoNotaNegociacao == "ENGIE BRASIL"):
        resposta = "Engie Brasil"
    elif nomeAtivoNotaNegociacao == "FII MAXI REN":
        resposta = "FII Maxi Renda"
    elif nomeAtivoNotaNegociacao == "FII XP LOG":
        resposta = "FII XP Log"
    elif (nomeAtivoNotaNegociacao == "ITAUSA"
          or nomeAtivoNotaNegociacao == "TAESA"
          or nomeAtivoNotaNegociacao == "PETROBRAS"
          or nomeAtivoNotaNegociacao == "BRADESCO"
          or nomeAtivoNotaNegociacao == "MOVIDA"):
        resposta = nomeAtivoNotaNegociacao.title()
    elif nomeAtivoNotaNegociacao == "KLABIN S/A":
        resposta = "Klabin S/A"
    elif nomeAtivoNotaNegociacao == "FII IRIDIUM":
        resposta = "FII Iridium Recebíveis Imobiliários"
    elif nomeAtivoNotaNegociacao == "ISHARE SP500":
        resposta = "iShares S&P 500 FIC de Fundo de Indice IE"
    elif nomeAtivoNotaNegociacao == "WEG          ON N":
        resposta = "Weg"
    elif nomeAtivoNotaNegociacao == "ITAUSA          PN":
        resposta = "Itausa"
    elif nomeAtivoNotaNegociacao == "TAESA          UNT":
        resposta = "Taesa"
    elif (nomeAtivoNotaNegociacao == "ABC BRASIL"
          or nomeAtivoNotaNegociacao == "ABC BRASI"):
        resposta = "Banco ABC Brasil"
    elif nomeAtivoNotaNegociacao == "OI":
        resposta = "OI Brasil"
    elif nomeAtivoNotaNegociacao == "METAL LEVE":
        resposta = "Mahle Metal Leve"
    elif nomeAtivoNotaNegociacao == "FII HSI MALL":
        resposta = "FII HSI Malls"
    elif nomeAtivoNotaNegociacao == "FII RBRALPHA":
        resposta = "FII RBR Alpha Multiestratégia Real Estate"
    elif nomeAtivoNotaNegociacao == "FII CSHG URB":
        resposta = "FII CSHG Renda Urbana"
    elif nomeAtivoNotaNegociacao == "FII VINCILOG":
        resposta = "fii Vinci Logistica"

    return resposta

def obterDataNotaNegociacao(texto):
    # Busca no texto padrão de escrita de dia/mês
    dia_mes = re.search(r'\d{2}/\d{2}', texto)

    if dia_mes is None:
        return None

    return dia_mes.group()

#tratar_registros_negociacao(['1-BOVESPA', 'V', 'FRACIONARIO', 'MOVIDA', 'ON NM', '', '', '6', '1', '9,85', '119,10 C', '28/12'])
leitura_notas_negociacao()
# obterDataNotaNegociacao("Texto 03/07/2020 Novo Texto")
