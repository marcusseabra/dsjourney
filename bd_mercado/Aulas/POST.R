
# HTTP POST

# - Envio de Formularios HTML
# - Web Services

#install.packages("httr")
library(httr)

ler.movimentacoes.POST = function(nome.carteira, dt){
  stopifnot(length(nome.carteira) == 1, nome.carteira %in% c("acoes", "juros"),
            length(dt) == 1, is(dt, "Date"))
  url = "http://localhost:9455/DownloadReport"
  r = POST(
    url = url, 
    body = list(name = nome.carteira, 
                date = format(dt, "%Y-%m-%d")))
  
  txt = content(r, as = "text", encoding = "UTF-8")
  
  dados = read.csv2(text = txt,  stringsAsFactors = FALSE)
  dados$data = as.Date(dados$data, "%Y-%m-%d")
  return(dados)
}
