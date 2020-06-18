if(!"httpuv" %in% installed.packages()[,1]){ install.packages("httpuv") }
if(!"Rook" %in% installed.packages()[,1]){ install.packages("Rook") }
library(httpuv)
library(Rook)


parse.query.string = function(str){
  str = gsub("^\\?", "", str)
  data = read.table(text=gsub("&", "\n", str), sep="=", stringsAsFactors = FALSE)
  out = decodeURI(data[,2])
  names(out) = data[,1]
  as.list(out)
}

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

      datas = seq(as.Date("2018-07-01"), as.Date("2018-07-15"), by = "day")

      list(
        status = 200,
        headers = list('Content-Type' = 'text/html'),
        body = paste0(
          '<!DOCTYPE html>',
          '<html>',
          '<head>',
          '	<title>Movimentacoes das Carteiras Gerenciais</title>',
          '</head>',
          '<body>',
          '	<h1>Movimentacoes das Carteiras Gerenciais</h1>',
          '	<h2>Carteira de Acoes</h2>',
          "  <ul>",
          paste(sapply(X = datas,
                 FUN = format,
                 format = '<li><a href="DownloadReport?name=acoes&date=%d/%m/%Y">%d/%m/%Y</a></li>'), collapse = " "),
          "</ul>",
          '	<h2>Carteira de Juros</h2>',
          '	<ul>',
          paste(sapply(X = datas,
                       FUN = format,
                       format = '<li><a href="DownloadReport?name=juros&date=%d/%m/%Y">%d/%m/%Y</a></li>'), collapse = " "),
          '	</ul>',
          '</body>',
          '</html>'
        )
      )

    } else if(req$PATH_INFO == "/DownloadReport"){

      R = Request$new(req)
      print(R$query_string())
      data = parse.query.string(R$query_string())
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
      dt = as.Date(data$date, "%d/%m/%Y")
      if(is.na(dt)){
        return(list(status=500, headers = list('Content-Type' = 'text/html'), body="data invalida"))
      }

      df = generate.operations(data$name, dt)
      body = c(capture.output(write.csv2(df, "", row.names = F)), "\n")

      out = list(
        status = 200,
        headers = list(
          'Content-Type' = 'text/csv',
          'Cache-Control' =  'no-cache',
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

browseURL("http://localhost:9454/Index")
runServer("0.0.0.0", 9454, app, 250)



