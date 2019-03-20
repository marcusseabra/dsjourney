# Faceting
# Reference: http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/

rs <- library(reshape2)

head(tips)

summary(tips)

str(tips)

library(ggplot2)

# Scatterplot
sp <- ggplot(tips, aes(x=total_bill, y=tip/total_bill)) + geom_point(shape=1)
sp

# A função facet_grig() promove o faceting ao se indicar variável de agrupamento e 
# o modo vertical ou horizontal

sp + facet_grid(sex ~ .)

sp + facet_grid(. ~ sex)

sp + facet_grid(sex ~ day)

# A função facet_wrap() efetua o faceting e estabelece o número de colunas

sp + facet_wrap(. ~ day, ncol = 2)

##############################################################################################

setwd('/home/seabra/dev/dsjourney-old/EDA/lesson3')

pf <- read.csv('pseudo_facebook.tsv', sep = '\t') 

library(ggplot2) 

qplot(x = friend_count, data = pf) +
  scale_x_continuous(limits = c(0, 1000))

qplot(x = friend_count, data = pf, xlim = c(0, 1000))

str(pf)

qplot(x = friend_count, data = pf, binwidth = 25) +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0, 1000, 100)) +
  facet_grid(~gender)

# Removendo registros em que o gênero não foi informado (na)
qplot(x = friend_count, data = subset(pf, !is.na(gender)), binwidth = 25) +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0, 1000, 100)) +
  facet_grid(~gender)

table(pf$gender)

by(pf$friend_count, pf$gender, summary)

# Em situações em que o histograma apresenta 'cauda longa', a mediana é uma medida mais robusta
# que a média porque esta característica indica que há valores puxando a média para um valor 
# mais alto (ou mais baixo)