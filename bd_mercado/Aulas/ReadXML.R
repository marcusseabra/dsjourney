library(XML)

doc = xmlParse("Dados/carteira.xml")
doc

root = xmlRoot(doc)

lista.dados = xmlElementsByTagName(root, "dado")

valores = getChildrenStrings(lista.dados[[1]])
valores

dados = data.frame()
for(i in 1:length(lista.dados)){
  
  dado = lista.dados[[i]]
  valores = getChildrenStrings(dado)
  d = as.data.frame(t(valores), stringsAsFactors = FALSE)
  dados = rbind(dados, d)
  
}

dados$id = as.numeric(dados$id)
dados$data = as.Date(dados$data, "%Y-%m-%d")
dados$vencimento = as.Date(dados$vencimento, "%Y-%m-%d")
dados$quantidade = as.numeric(dados$quantidade)
dados$preco = as.numeric(dados$preco)


filhos = xmlChildren(dado)

xmlValue(filhos[[2]])
