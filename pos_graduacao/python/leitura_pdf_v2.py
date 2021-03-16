import pdfplumber


def leitura_arquivos_pdf():
    # pdfplumber.open retorna instância da classe pdfplumber.PDF
#    with pdfplumber.open("/home/seabra/Documentos/Pessoal/Investimentos/Extrato_XP.pdf") as pdf:
#        primeira_pagina = pdf.pages[0]
#        print(primeira_pagina.chars[0])

#        metadados = pdf.metadata
#        print(metadados)

        # print(primeira_pagina.extract_text(x_tolerance=2, y_tolerance=2))

    with pdfplumber.open("/home/seabra/Documentos/IR_2021/Triunfo.pdf", password = "027") as pdf:
        primeira_pagina = pdf.pages[0]
        print(primeira_pagina.chars[0])

        # print(primeira_pagina.extract_text(x_tolerance=2, y_tolerance=2))
        # print(primeira_pagina.extract_tables())
        print(primeira_pagina.find_tables())


leitura_arquivos_pdf()
