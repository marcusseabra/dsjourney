import os
import re

DATADIR='/home/seabra/dev/udacity/modulo-1/de_para'
DATADIR_DESTINO='/home/seabra/dev/udacity/modulo-1/'

def leitura_arquivos():
    novasLinhas = []
    inclusoesSubcategorias = []
    nomesArquivos = []
    # Lista arquivos de uma pasta
    for nome in os.listdir(DATADIR):
        nomesArquivos.append(nome)
    nomesArquivos.sort()

    for indice in range(len(nomesArquivos)):
        arquivo = open(os.path.join(DATADIR, nomesArquivos[indice]), 'r')
        # Promove a leitua de linhas de um arquivo
        for linhas in arquivo:
            if re.search('SET SERVEROUTPUT ON FORMAT WRAPED;', linhas):
                continue
            if re.search('DECLARE', linhas):
                continue
            if re.search('CONTADOR NUMBER;', linhas):
                continue
            if re.search('TOTAL_SUBCATEGORIA NUMBER;', linhas):
                continue
            if re.search('QT_ECONOMIAS_CONFLITO NUMBER;', linhas):
                continue
            if re.search('BEGIN', linhas):
                continue
            if re.search('END;', linhas):
                continue
            if re.search('INSERT INTO CADASTRO.SUBCATEGORIA', linhas):
                inclusoesSubcategorias.append(linhas)
                continue

            novasLinhas.append(linhas)
        arquivo.close()

    arquivoFinal = open(os.path.join(DATADIR_DESTINO, "script_rm_20028_00_procedure_de_para_subcategorias.sql"), 'w')
    arquivoFinal.writelines(novasLinhas)
    arquivoFinal.close()

    arquivoFinal = open(os.path.join(DATADIR_DESTINO, "script_rm_20028_00_inclusoes_subcategorias.sql"), 'w')
    arquivoFinal.writelines(inclusoesSubcategorias)
    arquivoFinal.close()


def teste():
    leitura_arquivos()

teste()
