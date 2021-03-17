import pdfplumber
import pandas as pd


def leitura_arquivos_pdf():
    print("Versao de leitura das tabelas #########################################################################################\n")
    table_settings = {
        "vertical_strategy": "text",
        "horizontal_strategy": "text",
        "intersection_x_tolerance": 15
    }
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
    '''
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
