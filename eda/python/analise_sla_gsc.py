# -*- coding: utf-8 -*-
import os
import re
import csv
from datetime import datetime

DATADIR='/home/seabra/dev/udacity/modulo-1/util/Indicadores/'
DATADIR_DESTINO='/home/seabra/dev/udacity/modulo-1/'

ARQUIVO_TRANSICAO_RMS = "IND - Transicao RMs.csv"
ARQUIVO_RESPONSAVEIS_RMS = "IND - Responsaveis.csv"
FORMATO_DATA_HORA = "%Y-%m-%d %H:%M:%S"

def leitura_transicao():
    transicoes_rms = []

    with open(os.path.join(DATADIR, ARQUIVO_TRANSICAO_RMS), 'rt') as arquivo_csv:
        reader = csv.DictReader(arquivo_csv, delimiter = ';')
        for linhas in reader:
            transicoes_rms.append(linhas)

    arquivo_csv.close()
    return transicoes_rms

def evolucao_rms():
    lista_tempo_espera = []
    transicoes_rms = leitura_transicao()
    rm_anterior = 0
    for transicoes in transicoes_rms:
        rm_atual = transicoes['rm']
        if transicoes['situacao_atual'] == "Homologada" or transicoes['situacao_atual'] == "Concluída":
            if rm_atual != rm_anterior:
                tempo_espera = {}
                dataHoraCriacao = datetime.strptime(transicoes['criacao_rm'], FORMATO_DATA_HORA)
                dataHoraAtual = datetime.strptime(transicoes['transicao'], FORMATO_DATA_HORA)
                delta = dataHoraInicial - dataHoraAtual
                tempo_espera['rm'] = rm_atual
                tempo_espera['tempo'] = delta.days
                lista_tempo_espera.append(tempo_espera)
                rm_anterior = rm_atual
                transicao_inicial = True
                tempo_transicao = 0
            elif rm_atual == rm_anterior and transicao_inicial:
                dataHoraAtual = datetime.strptime(transicoes['transicao'], FORMATO_DATA_HORA)
                delta = dataHoraAtual - dataHoraInicial
                tempo_transicao = delta.days

def definicao_responsaveis():
    transicoes_rms = leitura_transicao()
    responsaveis_rms = []

    with open(os.path.join(DATADIR, ARQUIVO_RESPONSAVEIS_RMS), 'rt') as arquivo_csv:
        reader = csv.DictReader(arquivo_csv, delimiter = ';')
        for linhas in reader:
            responsaveis_rms.append(linhas)

    arquivo_csv.close()

    for transicoes in transicoes_rms:
        dataHoraTransicao = datetime.strptime(transicoes['data_transicao'], "%Y-%m-%d %H:%M:%S")
        if transicoes['rm'] == "13593":
            for responsaveis in responsaveis_rms:
                if responsaveis['rm'] == transicoes['rm']:
                    dataHoraResponsavel = datetime.strptime(responsaveis['data_atribuicao'], "%Y-%m-%d %H:%M:%S")
                    if dataHoraTransicao < dataHoraResponsavel:
                        print(transicoes['situacao_anterior']
                                + " - "
                                + responsaveis['responsavel']
                                + " - "
                                + responsaveis['data_atribuicao'])
                    elif dataHoraResponsavel == dataHoraTransicao:
                        print(transicoes['situacao']
                                + " - "
                                + responsaveis['responsavel']
                                + " - "
                                + responsaveis['data_atribuicao'])

evolucao_rms()
