# LISTAS
# Criando
lista = list(2L, 900.3, "abcdef", as.Date("2018-01-01"), 2:10)

# Lendo um elemento
lista[[1]]
lista[[2]]

# Modificando um elemento
lista[[3]] = "abcdefg"

# Listas nomeadas
lista.nomeada = list(
  nome = "acoes",
  codigo = 3,
  data = as.Date("2018-01-01"),
  papeis = 2:10
)

# Lendo um elemento
lista.nomeada[["nome"]]
lista.nomeada$codigo
lista.nomeada[[3]]

