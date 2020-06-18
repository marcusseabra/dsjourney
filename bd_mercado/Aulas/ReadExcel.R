library(readxl)

dados = read_excel("Dados/carteira.xlsx", sheet = "carteira2")

dados = as.data.frame(dados)
dados$data = as.Date(dados$data)
dados$vencimento = as.Date(dados$vencimento)


