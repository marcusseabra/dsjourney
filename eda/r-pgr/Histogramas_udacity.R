setwd('/home/seabra/dev/dsjourney-old/EDA/lesson3')

pf <- read.csv('pseudo_facebook.tsv', sep = '\t') 

library(ggplot2) 

qplot(x = friend_count, data = pf) +
  scale_x_continuous(limits = c(0, 1000))

qplot(x = friend_count, data = pf, xlim = c(0, 1000))

str(pf)

summary(pf)

qplot(x = friend_count, data = pf, binwidth = 25) +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0, 1000, 100)) +
  facet_grid(~gender)
      
# Dado inexistente
# https://www.statmethods.net/input/missingdata.html

# Removendo registros em que o gênero não foi informado (na)
qplot(x = friend_count, data = subset(pf, !is.na(gender)), binwidth = 25) +
  scale_x_continuous(limits = c(0,1000), breaks = seq(0, 1000, 100)) +
  facet_grid(~gender)

# Histograma similar com ggplot
ggplot(aes(x = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_histogram() + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  facet_wrap(~gender)

# Conta as ocorrências
table(pf$gender)

# A função by leva como argumento outra função, neste caso, 'summary'
by(pf$friend_count, pf$gender, summary)
help("by")

# Em situações em que o histograma apresenta 'cauda longa', a mediana é uma medida mais robusta
# que a média porque esta característica indica que há valores puxando a média para um valor 
# mais alto (ou mais baixo)

qplot(x = tenure, data = pf, binwidth = 30, color = I('black'), fill = I('#099DD9'))
ggplot(aes(x = tenure), data = pf) + 
  geom_histogram(binwidth = 30, color = 'black', fill = '#099DD9')

qplot(x = tenure/365, data = pf, binwidth = 1, color = I('black'), fill = I('#099DD9'))

qplot(x = tenure/365, data = pf, binwidth = .25, color = I('black'), fill = I('#099DD9'))

qplot(x = tenure/365, data = pf, binwidth = .25, color = I('black'), fill = I('#099DD9')) +
  scale_x_continuous(breaks = seq(1, 7, 1), lim = c(0, 7))

qplot(x = tenure/365, data = pf, 
      xlab = 'Número de anos usando o Facebook',
      ylab = 'Número de usuários na amostra',
      binwidth = .25, color = I('black'), fill = I('#F79420')) +
  scale_x_continuous(breaks = seq(1, 7, 1), lim = c(0, 7))

ggplot(aes(x = tenure / 365), data = pf) + 
  geom_histogram(color = 'black', fill = '#F79420') + 
  scale_x_continuous(breaks = seq(1, 7, 1), limits = c(0, 7)) + 
  xlab('Número de anos usando o Facebook') + 
  ylab('Número de usuários na amostra')

# Criando histograma para a variável idade ('age')
qplot(x = age, data = pf, 
      xlab = 'Idade dos usuários do Facebook',
      ylab = 'Número de usuários na amostra',
      binwidth = 5, color = I('black'), fill = I('#5760AB')) +
  scale_x_continuous(breaks = seq(10, 120, 5), lim = c(0, 120))

# Cientista de dados Lada Adamic
# http://www.ladamic.com/

# Aplicando funções sobre variáveis para torná-las similares a distribuições normais
summary(pf$friend_count)
summary(log10(pf$friend_count))

summary(log10(pf$friend_count + 1))

summary(sqrt(pf$friend_count))

# Estudo
# ggplot2 – Multiple Plots in One Graph Using gridExtra
# http://lightonphiri.org/blog/ggplot2-multiple-plots-in-one-graph-using-gridextra

# Adicione Log ou Escala Sqrt Scales em um Eixo 
# https://ggplot2.tidyverse.org/reference/scale_continuous.html

# Suposições de Regressão Linear 
# https://en.wikipedia.org/wiki/Linear_regression#Assumptions

# Distribuição Normal
# https://en.wikipedia.org/wiki/Normal_distribution

# Transformações de Log dos Dados
# https://www.r-statistics.com/2013/05/log-transformations-for-skewed-and-wide-distributions-from-practical-data-science-with-r/