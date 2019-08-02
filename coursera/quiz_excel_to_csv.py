# -*- coding: utf-8 -*-
'''
Find the time and value of max load for each of the regions
COAST, EAST, FAR_WEST, NORTH, NORTH_C, SOUTHERN, SOUTH_C, WEST
and write the result out in a csv file, using pipe character | as the delimiter.

An example output can be seen in the "example.csv" file.
'''

import xlrd
import os
import csv
from zipfile import ZipFile

datafile = "2013_ERCOT_Hourly_Load_Data.xls"
outfile = "2013_Max_Loads.csv"


def open_zip(datafile):
    with ZipFile('{0}.zip'.format(datafile), 'r') as myzip:
        myzip.extractall()


def parse_file(datafile):
    workbook = xlrd.open_workbook(datafile)
    sheet = workbook.sheet_by_index(0)
    data = []

    # YOUR CODE HERE
    # Remember that you can use xlrd.xldate_as_tuple(sometime, 0) to convert
    # Excel date to Python tuple of (year, month, day, hour, minute, second)

    colunas = {}

    for col in range(sheet.ncols):
        if sheet.cell_value(0, col) == 'COAST':
            colunas['COAST'] = col
        elif sheet.cell_value(0, col) == 'EAST':
            colunas['EAST'] = col
        elif sheet.cell_value(0, col) == 'FAR_WEST':
            colunas['FAR_WEST'] = col
        elif sheet.cell_value(0, col) == 'NORTH':
            colunas['NORTH'] = col
        elif sheet.cell_value(0, col) == 'NORTH_C':
            colunas['NORTH_C'] = col
        elif sheet.cell_value(0, col) == 'SOUTHERN':
            colunas['SOUTHERN'] = col
        elif sheet.cell_value(0, col) == 'SOUTH_C':
            colunas['SOUTH_C'] = col
        elif sheet.cell_value(0, col) == 'WEST':
            colunas['WEST'] = col

    for col_time in range(sheet.ncols):
        if sheet.cell_value(0, col_time) == 'Hour_End':
            break

    for key in colunas:
        item = {}
        for row in range(1, sheet.nrows):
            cellValue = float(sheet.cell_value(row, colunas[key]))
            if row == 1:
                maxValue = cellValue
            if cellValue > maxValue:
                maxValue = cellValue
                maxValueTime = xlrd.xldate_as_tuple(sheet.cell_value(row, col_time), 0)
        item['station'] = key
        item['max_load'] = maxValue
        item['max_time'] = maxValueTime
        data.append(item)

    return data

def save_file(data, filename):
    # YOUR CODE HERE
    fields = ['Station', 'Year', 'Month', 'Day', 'Hour', 'Max Load']
    linhas = []
    linha = ""

    for i in range(len(fields)):
        if i == len(fields) - 1:
            linha = linha + fields[i]
        else:
            linha = linha + fields[i] + "|"
    linha = linha + "\n"
    linhas.append(linha)
    linha = ""

    for i in range(len(data)):
        item = data[i]
        linha = item['station']
        linha = linha + "|" + str(item['max_time'][0])
        linha = linha + "|" + str(item['max_time'][1])
        linha = linha + "|" + str(item['max_time'][2])
        linha = linha + "|" + str(item['max_time'][3])
        linha = linha + "|" + str(item['max_load'])
        linha = linha + "\n"
        linhas.append(linha)
        linha = ""

    arquivoFinal = open(filename, 'w')
    arquivoFinal.writelines(linhas)
    arquivoFinal.close()

def test():
    open_zip(datafile)
    data = parse_file(datafile)
    save_file(data, outfile)

    number_of_rows = 0
    stations = []

    ans = {'FAR_WEST': {'Max Load': '2281.2722140000024',
                        'Year': '2013',
                        'Month': '6',
                        'Day': '26',
                        'Hour': '17'}}
    correct_stations = ['COAST', 'EAST', 'FAR_WEST', 'NORTH',
                        'NORTH_C', 'SOUTHERN', 'SOUTH_C', 'WEST']
    fields = ['Year', 'Month', 'Day', 'Hour', 'Max Load']

    with open(outfile) as of:
        csvfile = csv.DictReader(of, delimiter="|")
        for line in csvfile:
            station = line['Station']
            if station == 'FAR_WEST':
                for field in fields:
                    # Check if 'Max Load' is within .1 of answer
                    if field == 'Max Load':
                        max_answer = round(float(ans[station][field]), 1)
                        max_line = round(float(line[field]), 1)
                        assert max_answer == max_line

                    # Otherwise check for equality
                    else:
                        assert ans[station][field] == line[field]

            number_of_rows += 1
            stations.append(station)

        # Output should be 8 lines not including header
        assert number_of_rows == 8

        # Check Station Names
        assert set(stations) == set(correct_stations)


if __name__ == "__main__":
    test()
