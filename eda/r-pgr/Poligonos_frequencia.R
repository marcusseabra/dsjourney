setwd('/home/seabra/dev/dsjourney/eda/data')

pf <- read.csv('pseudo_facebook.tsv', sep = '\t') 

library(ggplot2) 

# Histograma
ggplot(aes(x = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_histogram() + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) + 
  facet_wrap(~gender)

# Polígono de frequencia
ggplot(aes(x = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_freqpoly(aes(color = gender), binwidth=10) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) +
  xlab('Variável - friend_count') +
  ylab('Percentual de usuários com a contagem de amigos')

# No eixo y pode-se usar uma notação que retorne proporções no lugar de contagem
ggplot(aes(x = friend_count, y = ..count../sum(..count..)), data = subset(pf, !is.na(gender))) + 
  geom_freqpoly(aes(color = gender), binwidth=10) + 
  scale_x_continuous(limits = c(0, 1000), breaks = seq(0, 1000, 50)) +
  xlab('Variável - friend_count') +
  ylab('Proporção com usuários')

# Use um polígono de frequência para determinar qual gênero dá mais curtidas na world wide web
ggplot(aes(x = www_likes), data = subset(pf, !is.na(gender))) + 
  geom_freqpoly(aes(color = gender)) +
  scale_x_continuous() +
  scale_x_log10() +
  xlab('Curtidas - friend_count') +
  ylab('Percentual de usuários com a contagem de amigos')

by(pf$www_likes, pf$gender, sum)

# https://flowingdata.com/2008/02/15/how-to-read-and-use-a-box-and-whisker-plot/
# https://en.wikipedia.org/wiki/Interquartile_range
# https://en.wikipedia.org/wiki/File:Boxplot_vs_PDF.svg

# Boxplots

ggplot(aes(x = gender, y = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_boxplot() +
  scale_y_continuous(limits = c(0, 1000))

# Segundo o instrutor, o uso de scale_y_continuous pode remover dados e por isso recomenda
# o uso de coord_cartesian
ggplot(aes(x = gender, y = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 1000))
  
ggplot(aes(x = gender, y = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 250))

by(pf$friend_count, pf$gender, summary)
