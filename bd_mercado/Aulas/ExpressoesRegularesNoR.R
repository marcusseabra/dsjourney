#### EXPRESSOES REGULARES NO R:

tweets = read.csv("Dados/tweets.csv", stringsAsFactors = F)

# GREPL: retorna vetor logical (TRUE/FALSE) 
# indicando se determinada string casou com o padrao
v = c("cama", "carro", "porta", "casa")
grepl(pattern = "ca.a", x = v)

View(tweets[grepl("^Sun", tweets$date),])             # no domingo
View(tweets[grepl("(\\d{2}):\\1:\\1", tweets$date),]) # p.ex: 23:23:23
View(tweets[grepl("00:00:", tweets$date),])           # meia noite

View(tweets[grepl("^[Jj]ohn", tweets$user),])         # usuario john

View(tweets[grepl("#\\w+", tweets$text),])            # tem hastag
View(tweets[grepl("@\\w+", tweets$text),])            # tem mention
View(tweets[grepl("@\\w+", tweets$text) & grepl("#\\w+", tweets$text),]) # hashtag e mention
View(tweets[grepl("@\\w+", tweets$text) | grepl("#\\w+", tweets$text),]) # hashtag ou mention
View(tweets[grepl("http://[^ \"]+", tweets$text),]) # http url

# GSUB: substitui padrao por outro
v
gsub(pattern = "a", replacement = "o", x = v)
gsub("a$", "o", v)

ts = tweets[grepl("\\s{2,}", tweets$text),] # multiplos espacos
head(ts$text)
novo = gsub(pattern = "\\s{2,}", replacement = " ", x = ts$text) # eliminando
head(novo)
ts$text = novo

View(gsub("http://[^ \"]+", "<URL>", tweets$text)) # eliminando urls
