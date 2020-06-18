library(stringr)

# str_extract_all: retorna lista com todos os casamentos de uma expressao 
# regular sobre um vetor

strings = c("10 e 20", "30", "40 ou 50", "60")
pattern = "\\d+"

m = str_extract_all(str_flatten(strings, "\n"), pattern)[[1]]
m

# str_match_all: retorna tambem os grupos!
strings = c("20.03", "30/03 ou 31/03", "25 04", "29.04 e 30.04")
pattern = "(\\d{2})[. /](\\d{2})"

m = str_match_all(str_flatten(strings, "\n"), pattern)[[1]]
m
paste(m[,2], m[,3], sep="/")

# EXEMPLO: BASE DE TWEETS

tweets = read.csv("Dados/tweets.csv", stringsAsFactors = F)

# contar de hashtags
textos = paste(tweets$text, collapse = "\n") 
m = str_extract_all(textos, "#\\w+")[[1]]
length(m)
m = str_to_lower(m) # mudar tudo para minusculas
count = table(m)    # contar repetidos
View(sort(count))   # ver em ordem

str_extract_all(textos, "http://([^\\s]+)")[[1]] # http urls

m = str_match_all(textos, "(\\d{1,2})\\D?(\\d{2})? ?([ap]m)\\W")[[1]] # horas

paste(m[,2], ifelse(test = is.na(m[,3]), yes = "00", no = m[,3]), m[,4], sep = " ")
