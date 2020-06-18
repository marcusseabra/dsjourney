# CONTROLE DE FLUXO

# CONDICIONAL: IF
x = 10
if(x > 5){
  print(x)
}

# CONDICIONAL: IF...ELSE
y = 2L
if(y != 0L){
  print(paste(y, "registros inseridos."))
} else {
  print("Nenhum registro inserido.")
}


# LOOPS: for()
for(i in 1:5){
  print(i)
}

# EXEMPLO: carga de dados
carregar.dados = function(dt){
  # validacoes
  stopifnot(is(dt, "Date"), length(dt) == 1)
  # carga de dados
  # (...)
  # fim da carga de dados
  msg = format(dt, "Dados carregados com sucesso para %d/%m/%Y!")
  print(msg)
}

datas = seq(from = as.Date("2018-06-28"), as.Date("2018-07-03"), by="day")

for(i in 1:length(datas)){
  dt = datas[i]
  carregar.dados(dt)
}
