#######################################################################
#
#              INTRODUCAO AO R: FORMATO DE DADOS
#
#######################################################################

# Tipos de dados
# Numeros
x = 1
y = 1.5

x+y

x = 5:10
str(x)
y = c(50, 60, 70, 80, 90, 100)
str(y)

(x+y) == (11 * x)

# Textos
s = c("ola", "mundo")
paste(s, collapse = ", ")

z = c(10, 15, "ola")
str(z)

lista = list(10, 15, "ola")



df = data.frame(
  id = 1:4,
  valor = c(10, 20, 30, 40),
  descricao = c("alo", "ola", "mundo", "domun"),
  stringsAsFactors = FALSE
)

View(iris)

iris$Sepal.Length
iris[,"Sepal.Length"]

iris[c(10, 20, 30), c("Species", "Sepal.Length")]

iris[iris$Sepal.Length > mean(iris$Sepal.Length) & iris$Species == "virginica" , ]
