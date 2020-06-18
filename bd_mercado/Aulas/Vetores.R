# VETORES

# Criando
v1 = c(10, 20, 30, 40) # concatena (junta) os elementos em um vetor
v2 = 1:4               # atalho para criar vetor com sequencias

# Lendo
v1[1]
v1[3]
v1[c(2,4)]
v1[c(TRUE, FALSE, TRUE, TRUE)]
v1[v1 > 25]

# Modificando
v1[3] = 35
v1
v1[v1 < 30] = 0
v1

# Vetorizacao
v1 = c(10, 20, 30, 40)
v2  = 1:4
length(v1)
length(v2)
v1 + v2
v1 * v2

# Operacoes com escalares
v1-2
v1^2
v1/10
