# DIAS UTEIS

# Pacote bizdays
#install.packages("bizdays") # instala o pacote
library(bizdays) # carrega o pacote

# criando calendario com feriados ANBIMA
holidaysANBIMA
create.calendar(name = "ANBIMA", holidays=holidaysANBIMA, weekdays=c("saturday", "sunday"))

# verificando se uma data eh dia util
d1 = as.Date("2018-01-07")
d1
d2 = as.Date("2018-01-17")
d2
is.bizday(d1, "ANBIMA")
is.bizday(d2, "ANBIMA")

# verificando se uma data eh dia util (vetorizado)
datas = seq(d1, d2, by="day")
datas
is.bizday(datas, "ANBIMA")

# gerando vetor de datas uteis
bizseq(from = d1, to = d2, cal = "ANBIMA")

# dias uteis entre datas
bizdays(from = d1, to = d2, cal = "ANBIMA")

# avancando (recuando) n dias uteis
add.bizdays(as.Date("2018-01-12"), n = 1, "ANBIMA")
add.bizdays(as.Date("2018-01-15"), n = -2, "ANBIMA")

# ajuste para data util mais proxima
adjust.next(as.Date("2018-01-13"), "ANBIMA")
adjust.previous(as.Date("2018-01-13"), "ANBIMA")

#### EXEMPLO: PRECIFICACAO DE UMA NTN-F
data.base = as.Date("2018-07-10")
vencimento = as.Date("2021-01-01")
tir = 9.04

proximos.pgtos = seq(from = vencimento, to = data.base, by = "-6 months")
proximos.pgtos
rev(proximos.pgtos)
proximos.pgtos = rev(proximos.pgtos)
proximos.pgtos
proximos.pgtos = adjust.next(proximos.pgtos, "ANBIMA")
proximos.pgtos

du = bizdays(from = data.base, to = proximos.pgtos, cal = "ANBIMA")
du

principal = 1000
juros = ((1+10/100)^(1/2) - 1) * principal
juros

# valor futuro
vf = rep(juros, length(proximos.pgtos)) # pgtos de juros
vf[length(vf)]
vf[length(vf)] = vf[length(vf)] + principal # adicionando principal no ultimo pgto
vf

# calculo do preco
vp = vf / ((1+tir/100)^(du/252)) 
vp
preco = sum(vp)
preco

# data frame com detalhamento da precificacao
ntn.f = data.frame(
  datas = proximos.pgtos,
  prazo.du = du,
  vf = vf,
  vp = vp
)

ntn.f
data.base
vencimento
tir
preco

