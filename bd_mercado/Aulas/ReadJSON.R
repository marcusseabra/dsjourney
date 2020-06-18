library(jsonlite)

dados = fromJSON("Dados/carteira.json")
dados
str(dados)

dados$data = as.Date(dados$data, "%Y-%m-%d")
dados$vencimento = as.Date(dados$vencimento, "%Y-%m-%d")

str(dados)
