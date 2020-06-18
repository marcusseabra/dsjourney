if(!"httpuv" %in% installed.packages()[,1]){ install.packages("httpuv") }
if(!"Rook" %in% installed.packages()[,1]){ install.packages("Rook") }
library(httpuv)
library(Rook)

generate.operations = function(name, date){
  stopifnot(is(date, "Date"), length(date) == 1,
            is.character(name), length(name) == 1)
  
  if(name == "acoes"){
    tickers = c("PETR4", "VALE3", "CMIG3", "ITUB4")
    set.seed(as.numeric(date))
  } else if(name == "juros"){
    tickers = c("LTN 2021", "LFT 2021", "NTN-B 2025", "NTN-B 2050")
    set.seed(as.numeric(date)+123456)
  } else {
    stop("carteira invalida")
  }
  
  
  df = data.frame(
    id = 1:4,
    data = date,
    ticker = tickers,
    movimento = sample(c("compra", "venda"), 4, T),
    quantidade = sample((1:100)*100, 4, T),
    stringsAsFactors = FALSE
  )
  
  return(df)
}

app <- list(
  call = function(req) {
    
    print(req$PATH_INFO)
    
    if(req$PATH_INFO == "/Index"){
      
      list(
        status = 200,
        headers = list('Content-Type' = 'text/html'),
        body = paste0(
          '<!DOCTYPE html>',
          '<html>',
          '<head>',
          '	<title>Carteiras</title>',
          '</head>',
          '<body>',
          '	<h1>Download das Movimentacoes</h1>',
          '	<form method="POST" action="/DownloadReport">',
          '		<select name="name" required>',
          '			<option value="acoes" selected>Carteira de Acoes</option>',
          '			<option value="juros">Carteira de Juros</option>',
          '		</select>',
          '		<input type="date" name="date" placeholder="dd/mm/aaaa">',
          '		<button>Download</button>',
          '	</form>',
          '</body>',
          '</html>'
        )
      )
      
    } else if(req$PATH_INFO == "/DownloadReport"){
      
      data = Request$new(req)$POST()
      print(data)
      
      if(!"name" %in% names(data)){
        return(list(status=500, headers = list('Content-Type' = 'text/html'), body="nome nao informado"))
      }
      if(!data$name %in% c("acoes", "juros")){
        return(list(status=500, headers = list('Content-Type' = 'text/html'), body="nome invalido"))
      }
      
      if(!"date" %in% names(data)){
        return(list(status=500, headers = list('Content-Type' = 'text/html'), body="data nao informada"))
      }
      dt = as.Date(data$date, "%Y-%m-%d") 
      if(is.na(dt)){
        return(list(status=500, headers = list('Content-Type' = 'text/html'), body="data invalida"))
      }
      
      df = generate.operations(data$name, dt)
      body = c(capture.output(write.csv2(df, "", row.names = F)), "\n")
      
      out = list(
        status = 200, 
        headers = list(
          'Content-Type' = 'text/csv',
          'Content-Disposition' = format(dt, paste0('attachment; filename="Operacoes-', data$name, '-%Y-%m-%d.csv"'))
        ), 
        body = paste(body, collapse = "\n")
      )
      
      return(out)
      
    } else {
      return(list(status = 404, headers = list('Content-Type' = 'text/html'), body="Page not found"))
    }
  }
)

browseURL("http://localhost:9455/Index")
runServer("0.0.0.0", 9455, app, 250)



