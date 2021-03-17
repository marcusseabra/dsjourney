import pdfplumber
import pandas as pd


def leitura_arquivos_pdf():
    # pdfplumber.open retorna instância da classe pdfplumber.PDF
#    with pdfplumber.open("/home/seabra/Documentos/Pessoal/Investimentos/Extrato_XP.pdf") as pdf:
#        primeira_pagina = pdf.pages[0]
#        print(primeira_pagina.chars[0])

#        metadados = pdf.metadata
#        print(metadados)

        # print(primeira_pagina.extract_text(x_tolerance=2, y_tolerance=2))

    with pdfplumber.open("/home/seabra/Documentos/IR_2021/Notas_Negociacao/Nota_Negociacao_2020-03-20.pdf", password = "027") as pdf:
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


leitura_arquivos_pdf()
