# DATAS NO R

d1 = as.Date("2018-05-07", "%Y-%m-%d")
class(d1)
d2 = as.Date("10/07/18", "%d/%m/%y")

# Adicionando dias
d1 + 1
d2 - 2
# Diferenca em dias corridos
d2-d1
dc = as.numeric(d2-d1)
(1 + 6/100)^(dc/360)-1

# Formatando data em strings
d1
format(d1, "%d/%m/%Y")
d2
format(d2, "%A, %d de %B de %Y")

# Sequencia de datas
seq(d1, d2, by="day")
seq(d1, d2, by="week")
seq(d1, d2, by="month")

