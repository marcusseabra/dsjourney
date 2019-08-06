import xlrd

datafile = "2013_ERCOT_Hourly_Load_Data.xls"

def parse_file(datafile):
    workbook = xlrd.open_workbook(datafile)

    sheet = workbook.sheet_by_index(0)

    for col_coast in range(sheet.ncols):
        if sheet.cell_value(0, col_coast) == 'COAST':
            break

    for col_time in range(sheet.ncols):
        if sheet.cell_value(0, col_time) == 'Hour_End':
            break

    averageValue = 0
    for row in range(1, sheet.nrows):
        cellValue = float(sheet.cell_value(row, col_coast))
        averageValue = averageValue + cellValue
        if row == 1:
            minValue = cellValue
            maxValue = cellValue
        if cellValue > maxValue:
            maxValue = cellValue
            maxValueTime = sheet.cell_value(row, col_time)
        if cellValue < minValue:
            minValue = cellValue
            minValueTime = sheet.cell_value(row, col_time)

    data = {
        'maxtime' : xlrd.xldate_as_tuple(maxValueTime, 0),
        'maxvalue' : maxValue,
        'mintime' : xlrd.xldate_as_tuple(minValueTime, 0),
        'minvalue' : minValue,
        'avgcoast' : averageValue/row
    }

    return data

def test():
    data = parse_file(datafile)

    assert data['maxtime'] == (2013, 8, 13, 17, 0, 0)
    assert round(data['maxvalue'], 10) == round(18779.02551, 10)

test()
