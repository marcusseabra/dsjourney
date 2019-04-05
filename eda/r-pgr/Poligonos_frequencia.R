setwd('/home/seabra/dev/dsjourney/eda/data')

pf <- read.csv('pseudo_facebook.tsv', sep = '\t') 

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
  geom_freqpoly(aes(color = gender), binwidth=10) + 
  scale_x_continuous(limits = c(0, 20), breaks = seq(0, 20, 5)) +
  xlab('Curtidas - friend_count') +
  ylab('Percentual de usuários com a contagem de amigos')

summary(pf$www_likes)
sd(pf$www_likes)
