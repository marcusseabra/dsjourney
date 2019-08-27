import csv
import os
import json

pasta_entrada = '/home/seabra/dev/dsjourney/compesa_gsc/data/input/'
pasta_saida = '/home/seabra/dev/dsjourney/compesa_gsc/data/output/'
pasta_processados = '/home/seabra/dev/dsjourney/compesa_gsc/data/processed'


def gerar_arquivo_redmine_json():
    extracao_redmine_csv = os.path.join(pasta_entrada, "demandas_GSC.csv")
    lista_demandas_gsc = []
    demanda = {}
    num_rm_atual = 0
    num_rm_anterior = 0
    teste = 10

    with open(extracao_redmine_csv, encoding='utf-8-sig') as arq:
        dados_csv = csv.DictReader(arq, delimiter=';')
        for row in dados_csv:
            num_rm_atual = int(row['num_rm'])
            if num_rm_atual != num_rm_anterior:
                demanda = {row['num_rm'], row['titulo']}
                print(demanda)
                num_rm_anterior = num_rm_atual
                teste -= 1
                if(teste < 0):
                    break
    arq.close()


def converter_atualizacao_redmine():
    return


gerar_arquivo_redmine_json()
