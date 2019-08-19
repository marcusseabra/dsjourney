import pandas as pd

input_dir = '/home/seabra/dev/dsjourney/coursera/modulo_python/data/input'


def leitura_arquivo():
    df = pd.read_csv('olympics.csv', index_col=0, skiprows=1, skipfooter=1)
    for col in df.columns:
        if col[:2] == '01':
            df.rename(columns={col: 'Gold' + col[4:]}, inplace=True)
        if col[:2] == '02':
            df.rename(columns={col: 'Silver' + col[4:]}, inplace=True)
        if col[:2] == '03':
            df.rename(columns={col: 'Bronze' + col[4:]}, inplace=True)
        if col[:1] == '№':
            df.rename(columns={col: '#' + col[1:]}, inplace=True)
    print(df.columns)
    # print(df.loc['Gold'].max())
    df.loc['Gold']


leitura_arquivo()