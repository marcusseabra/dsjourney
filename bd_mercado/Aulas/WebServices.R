###############################################################
#
#                            WEBSERVICES
#
# - Proveem servicos por meio da web
# - Integram aplicacoes
# - Caso especial: Servidores de dados
# - Protocolo de comunicacao / documentacao do servico:
#    - ESPECIFICACOES DE ENVIO:
#        * FORMA: HTTP POST, HTTP GET, etc
#        * "LINGUAGEM": XML, JSON, querystring, etc
#        * CONTEUDO: parametros de entrada
#    - ESPECIFICACOES DE RECEBIMENTO:
#        * "LINGUAGEM": XML, JSON, CSV, etc
#        * CONTEUDO: informacoes de saida
# - Especificacoes standard: REST, SOAP, etc

library(httr)
library(jsonlite)
library(XML)

#####################################################
# EXEMPLO XML

name = "juros"
dt = as.Date("2018-07-25")

# POST XML
xml.in = paste0(
  "  <parametros>",
  "    <name>", name, "</name>",
  "    <date>", format(dt, "%Y-%m-%d"), "</date>",
  "  </parametros>"
)

r = POST(
  url = "http://localhost:9455/movimentos/XML",
  body = xml.in
)

txt = content(r, as = "text")
print(txt)
xml.out = xmlParseString(txt)
dados = xmlToDataFrame(xml.out, stringsAsFactors = F)
dados$id = as.integer(dados$id)
dados$quantidade = as.integer(dados$quantidade)
dados$data = as.Date(dados$data, "%Y-%m-%d")
print(dados)


#####################################################
# EXEMPLO JSON

name = "acoes"
dt = as.Date("2018-07-29")

inputs = list(
  name = name,
  date = format(dt, "%Y-%m-%d")
)
json.in = toJSON(inputs, auto_unbox = T)


r = POST(
  url = "http://localhost:9455/movimentos/JSON",
  body = json.in
)

txt = content(r, as = "text")
print(txt)
dados = fromJSON(txt)
dados$data = as.Date(dados$data, "%Y-%m-%d")
print(dados)


