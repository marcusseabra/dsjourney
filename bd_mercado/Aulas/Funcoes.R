# FUNCOES

# Funcoes nativas do R
c(1,2,3,4)
# Funcoes definidas pelo usuario
square = function(x){
  x^2
}

square(5)
square(x = 10)

# parametros default
sum = function(x, y = 2) {
  x + y
}
sum(x = 1, y = 2)
sum(1)

# comando return
eh.par = function(x){
  if(x %% 2 == 0) {
    return("par")
  } else {
    return("impar")
  }
}
eh.par(10L)
eh.par(25L)
eh.par(c(10L, 25L))
eh.par(10.1)

# stopifnot: garantir o uso correto da funcao
eh.par2 = function(x){
  stopifnot(is.integer(x), length(x) == 1)
  if(x %% 2 == 0) {
    return("par")
  } else {
    return("impar")
  }
}

eh.par2(10L)
eh.par2(25L)
eh.par2(c(10L, 25L))
eh.par2(10.1)
