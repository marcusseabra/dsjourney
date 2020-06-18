
# HTTP GET

# - Envio de dados na URL
# - Querystring: nomes e valores apos a "?" separados por "&"
# - EXEMPLO: http://www.meusite.com/minhaPagina?nome1=valor1&nome2=valor2&(...)
# - Podemos simular a requisicao direto da barra de enderecos do browser


# HTTP GET

# - Envio de dados na URL
# - Querystring: nomes e valores apos a "?" separados por "&"
# - EXEMPLO: http://www.meusite.com/minhaPagina?nome1=valor1&nome2=valor2&(...)
# - Podemos simular a requisicao direto da barra de enderecos do browser


ler.movimentacoes.GET = function(nome.carteira, dt){
  stopifnot(length(nome.carteira) == 1, nome.carteira %in% c("acoes", "juros"),
            length(dt) == 1, is(dt, "Date"))
  
  url = paste0("http://localhost:9454/DownloadReport?",
               "name=", nome.carteira,
               "&date=", format(dt, "%d/%m/%Y"))
  
  dados = read.csv2(url, stringsAsFactors = F)
  dados$data = as.Date(dados$data, "%Y-%m-%d")
  return(dados)
  
}