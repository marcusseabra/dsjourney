library(XML)

doc = xmlParse("Dados/carteira.html")
root = xmlRoot(doc)

dados = readHTMLTable(root, stringsAsFactors = FALSE)

# nomeando as colunas com a primeira linha de dados
colnames(dados) = dados[1,]
# removendo a primeira linha
dados = dados[-1,]

# convertendo tipos de dados
dados$data = as.Date(dados$data, "%Y-%m-%d")
dados$vencimento = as.Date(dados$vencimento, "%Y-%m-%d")
dados$quantidade = as.numeric(dados$quantidade)
dados$preco = as.numeric(dados$preco)

str(dados)
dados
