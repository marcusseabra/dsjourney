import pdfplumber
import pandas as pd
import os

# https://github.com/jsvine/pdfplumber/blob/stable/examples/notebooks/extract-table-nics.ipynb
# https://github.com/jsvine/pdfplumber#extracting-tables

DATADIR = '/home/seabra/Documentos/IR_2021/Notas_Negociacao/'
DATADIR_DESTINO = '/home/seabra/Documentos/IR_2021/Notas_Negociacao/'

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
        pdf = pdfplumber.open(os.path.join(DATADIR, nomesArquivos[indice]))

        # A propriedade pages é uma lista com o total de páginas do arquivo pdf lido
        print("Número de páginas do arquivo: " + str(len(pdf.pages)) + "\n")
        for pgn in range(len(pdf.pages)):
            leitura_pagina = pdf.pages[pgn]

            dados_tabela = leitura_pagina.extract_table(table_settings)
            for linhas in dados_tabela:
                if linhas[0] == "1-BOVESPA":
                    lista_final.append(linhas)

    for item_negociacao in lista_final:
        print(item_negociacao)

#        primeira_pagina = pdf.pages[0]

        # A função extract_table obtém a maior tabela da página com base nos parâmetros (table_settings)
#        dados_tabela = primeira_pagina.extract_table(table_settings)
#        for linhas in dados_tabela:
#            if linhas[0] == "1-BOVESPA":
#                print(linhas)


    '''
    with pdfplumber.open("/home/seabra/Documentos/IR_2021/Notas_Negociacao/Nota_Negociacao_2020-06-26.pdf", password = "027") as pdf:
        # A propriedade pages é uma lista com o total de páginas do arquivo pdf lido
        print("Número de páginas do arquivo: " + str(len(pdf.pages)) + "\n")
        primeira_pagina = pdf.pages[0]

        dados_tabela = primeira_pagina.extract_table(table_settings)
        for linhas in dados_tabela:
            if linhas[0] == "1-BOVESPA":
                print(linhas)
        # print(primeira_pagina.chars[0])

        # print(primeira_pagina.extract_text(x_tolerance=2, y_tolerance=2))
        # print(primeira_pagina.extract_tables())

    print("#########################################################################################\n")
    with pdfplumber.open("/home/seabra/Documentos/IR_2021/Notas_Negociacao/Nota_Negociacao_2020-01-30.pdf", password = "027") as pdf:
        primeira_pagina = pdf.pages[0]
        # print(primeira_pagina.chars[0])

        print(primeira_pagina.extract_text(x_tolerance=2, y_tolerance=2))
        # print(primeira_pagina.extract_tables())

        i = 0
        for tabelas in primeira_pagina.find_tables():
            print("Indice da tabela encontrada: " + str(i))
            # Avaliar usar pandas para decodificar a tabela
            j = 0
            for linhas in tabelas.rows:
                print("\tIndice da linha encontrada: " + str(j))
                j = j + 1
            i = i + 1

        # print(primeira_pagina.find_tables())
        '''


leitura_arquivos_pdf()
