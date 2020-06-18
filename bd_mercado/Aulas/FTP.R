# Requisicoes FTP
# File Transfer Protocol

url = "ftp://ftp.ibge.gov.br/Censos/leia_me.txt"

# OPCAO #1: Lendo o arquivo diretamente
txt = readLines(url)
txt

# OPCAO #2: Fazendo o download
# Arquivos texto
download.file(url, destfile = "Downloads/arquivo.txt")
txt2 = readLines("Downloads/arquivo.txt")
txt2

all(txt == txt2)

# Arquivos binarios
url2 = "ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/resultados/taxa_crescimento_BRASIL.zip"
filename = "Downloads/dados.zip"
download.file(url2, destfile = filename, mode = "wb")

# Descompactar
files = unzip(filename, exdir = "Downloads")
files

# Remover arquivo
file.remove(files)
