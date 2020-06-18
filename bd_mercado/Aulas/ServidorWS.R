if(!"httpuv" %in% installed.packages()[,1]){ install.packages("httpuv") }
if(!"Rook" %in% installed.packages()[,1]){ install.packages("Rook") }
if(!"XML" %in% installed.packages()[,1]){ install.packages("XML") }
if(!"jsonlite" %in% installed.packages()[,1]){ install.packages("jsonlite") }
library(httpuv)
library(Rook)
library(XML)
library(jsonlite)

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

data.frame.to.xml = function(data){

  xml <- xmlTree("dados")
  # names(xml)
  for (i in 1:nrow(data)) {
    xml$addTag("dado", close=FALSE)
    for (j in colnames(data)) {
      xml$addTag(j, data[i, j])
    }
    xml$closeTag()
  }
  return(xmlDoc(xmlRoot(xml)))
}

app <- list(
  call = function(req) {

    print("NEW REQUEST TO:")
    print(req$PATH_INFO)

    if(toupper(req$PATH_INFO) == toupper("/Index")){
      return(
        list(status=200, headers = list('Content-Type' = 'text/html'), body=WS.documentation())
      )
    }


    R = Request$new(req)
    #print(R$content_type())
    data.unparsed = R$body()$read_lines()
    print("UNPARSED DATA:")
    print(data.unparsed)

    print("trying to parse json...")
    data = try(jsonlite::fromJSON(data.unparsed), silent = T)
    if(inherits(data, "try-error")){
      print("trying to parse xml...")
      xml = try(xmlParseString(data.unparsed), silent = T)
      if(!inherits(xml, "try-error")){
        data = as.list(getChildrenStrings(xml))
      } else {
        print("error parsing data.")
        data = list()
      }
    }

    print("PARSED DATA:")
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


    if(toupper(req$PATH_INFO) == toupper("/movimentos/XML")){

      doc = suppressWarnings(data.frame.to.xml(df))

      tmp = tempfile()
      saveXML(doc = doc, file = tmp)

      txt = readLines(tmp)
      file.remove(tmp)

      return(list(
        status = 200,
        headers = list('Content-Type' = 'application/xml; charset=utf-8'),
        body = paste(txt[-1], collapse = "\n")
      ))

    } else if(toupper(req$PATH_INFO) == toupper("/movimentos/JSON")){


      j = jsonlite::toJSON(df, auto_unbox = T)


      df = generate.operations(data$name, dt)
      body = c(capture.output(write.csv2(df, "", row.names = F)), "\n")

      out = list(
        status = 200,
        headers = list('Content-Type' = 'application/json; charset=utf-8'),
        body = as.character(j)
      )

      return(out)

    } else {
      return(list(status = 404, headers = list('Content-Type' = 'text/html'), body="Page not found"))
    }
  }
)


WS.documentation = function(){
  paste(c(
    '<!DOCTYPE html>',
    '<html>',
    '<head>',
    '<title>Documentação do WebService de Movimentações</title>',
    '</head>',
    '<body>',
    '<h1>Documentação do WebService de Movimentações</h1>',
    '',
    '<h2>Funcionalidade: Tabela de Movimentações</h2>',
    '<p>Fornece a tabela de movimentações (compras/vendas) para as carteiras da instituição financeira.</p>',
    '',
    '<h3>FORMA DE ACESSO #1: XML</h3>',
    '<ul>',
    '<li><strong>Requisição:</strong> HTTP POST</li>',
    '<li><strong>Endereço:</strong> <a href="http://localhost:9455/movimentos/XML">http://localhost:9455/movimentos/XML</a></li>',
    '<li><strong>Dados do POST:</strong> XML com parâmetros. Ver EXEMPLO XML DE ENTRADA.</li>',
    '<li><strong>Resposta:</strong> XML com dados. Ver EXEMPLO XML DE SAÍDA.</li>',
    '',
    '</ul>',
    '',
    '<h5>EXEMPLO XML DE ENTRADA:</h5>',
    '<pre>',
    '    &lt;?xml version="1.0"?&gt;',
    '    &lt;parametros&gt;',
    '        &lt;name&gt;acoes&lt;/name&gt;           <--- valores possiveis: juros, acoes',
    '        &lt;date&gt;2018-07-29&lt;/date&gt;      <--- data no formato aaaa-mm-dd',
    '    &lt;/parametros&gt;',
    '</pre>',
    '',
    '<h5>EXEMPLO XML DE SAÍDA:</h5>',
    '<pre>',
    '&lt;?xml version="1.0"?&gt;',
    '&lt;dados&gt;',
    '    &lt;dado&gt;',
    '        &lt;id&gt;1&lt;/id&gt;',
    '        &lt;data&gt;2018-07-29&lt;/data&gt;',
    '        &lt;ticker&gt;PETR4&lt;/ticker&gt;',
    '        &lt;movimento&gt;compra&lt;/movimento&gt;',
    '        &lt;quantidade&gt;9500&lt;/quantidade&gt;',
    '    &lt;/dado&gt;',
    '    &lt;dado&gt;',
    '        &lt;id&gt;2&lt;/id&gt;',
    '        &lt;data&gt;2018-07-29&lt;/data&gt;',
    '        &lt;ticker&gt;VALE3&lt;/ticker&gt;',
    '        &lt;movimento&gt;venda&lt;/movimento&gt;',
    '        &lt;quantidade&gt;9100&lt;/quantidade&gt;',
    '    &lt;/dado&gt;',
    '    &lt;dado&gt;',
    '        &lt;id&gt;3&lt;/id&gt;',
    '        &lt;data&gt;2018-07-29&lt;/data&gt;',
    '        &lt;ticker&gt;CMIG3&lt;/ticker&gt;',
    '        &lt;movimento&gt;venda&lt;/movimento&gt;',
    '        &lt;quantidade&gt;7900&lt;/quantidade&gt;',
    '    &lt;/dado&gt;',
    '    &lt;dado&gt;',
    '        &lt;id&gt;4&lt;/id&gt;',
    '        &lt;data&gt;2018-07-29&lt;/data&gt;',
    '        &lt;ticker&gt;ITUB4&lt;/ticker&gt;',
    '        &lt;movimento&gt;venda&lt;/movimento&gt;',
    '        &lt;quantidade&gt;2600&lt;/quantidade&gt;',
    '    &lt;/dado&gt;',
    '&lt;/dados&gt;',
    '</pre>',
    '',
    '<h3>FORMA DE ACESSO #2: JSON</h3>',
    '<ul>',
    '<li><strong>Requisição:</strong> HTTP POST</li>',
    '<li><strong>Endereço:</strong> <a href="http://localhost:9455/movimentos/JSON">http://localhost:9455/movimentos/JSON</a></li>',
    '<li><strong>Dados do POST:</strong> JSON com parâmetros. Ver EXEMPLO JSON DE ENTRADA.</li>',
    '<li><strong>Resposta:</strong> JSON com dados. Ver EXEMPLO JSON DE SAÍDA.</li>',
    '</ul>',
    '',
    '<h5>EXEMPLO JSON DE ENTRADA:</h5>',
    '<pre>',
    '    {',
      '        "name":"juros",          <--- valores possiveis: juros, acoes',
      '        "date":"2018-07-29"      <--- data no formato aaaa-mm-dd',
      '    }',
    '</pre>',
    '',
    '<h5>EXEMPLO JSON DE SAÍDA:</h5>',
    '<pre>',
    '    [',
    '       {',
    '          "id":1,',
    '          "data":"2018-07-29",',
    '          "ticker":"LTN 2021",',
    '          "movimento":"venda",',
    '          "quantidade":4000',
    '       },',
    '       {',
    '          "id":2,',
    '          "data":"2018-07-29",',
    '          "ticker":"LFT 2021",',
    '       "movimento":"venda",',
    '       "quantidade":2800',
    '       },',
    '       {',
    '          "id":3,',
    '          "data":"2018-07-29",',
    '          "ticker":"NTN-B 2025",',
    '          "movimento":"compra",',
    '          "quantidade":8900',
    '       },',
    '       {',
    '          "id":4,',
    '          "data":"2018-07-29",',
    '          "ticker":"NTN-B 2050",',
    '          "movimento":"venda",',
    '          "quantidade":1200',
    '       }',
    ' ]',
    '</pre>',
    '</body>',
    '</html>'
  ), collapse = "\n")

}


browseURL("http://localhost:9455/Index")
runServer("0.0.0.0", 9455, app, 250)



