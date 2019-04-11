options(repos='http://cran.rstudio.com/')
install.packages('ggplot2')
library(ggplot2)

dm <- diamonds

summary(dm)
str(dm$color)

# Sobre factor variable: https://stats.idre.ucla.edu/r/modules/factor-variables/

levels(dm$color)
?diamonds

# Histograma da variável preço (price)

ggplot(aes(x = price), data = dm) + 
  geom_histogram()

summary(dm$price)

# Geração de histogramas
# Importante: analisar os parâmetros aes, coord_cartesian, scale_x_continuous, scale_x_log10
ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 85, color = 'black', fill = '#F79420') +
  coord_cartesian(xlim = c(0, 20000)) + 
  xlab('Preço dos diamantes') + 
  ylab('Contagem')

hist_1 <- ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 85, color = 'black', fill = '#F79420') +
  coord_cartesian(xlim = c(0, 20000)) + 
  xlab('Preço dos diamantes') + 
  ylab('Contagem')

# A função ggsave salva o último gráfico gerado
ggsave('/home/seabra/dev/dsjourney/eda/data/Histograma.png')
help("ggsave")

ggsave('/home/seabra/dev/dsjourney/eda/data/Histograma.png', hist_1)

# Utilização do faceting
ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 85, color = 'black', fill = '#F79420') +
  coord_cartesian(xlim = c(0, 20000)) + 
  xlab('Preço dos diamantes') + 
  ylab('Contagem') +
  facet_wrap(~cut)

# Avaliar o uso recomendado de scale_x_log10
ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 0.025, color = 'black', fill = '#F79420') +
  scale_x_log10() 

summary(log10(dm$price + 1))

ggsave('/home/seabra/dev/dsjourney/eda/data/Histograma_Log.png')

# Avaliar o uso recomendado de scale_x_sqrt
ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 2, color = 'black', fill = '#F79420') +
  scale_x_sqrt() 

summary(sqrt(dm$price))

ggsave('/home/seabra/dev/dsjourney/eda/data/Histograma_sqtr.png')

# Utilizando conceito de subconjuntos para avaliar os dados
nrow(subset(dm, dm$price < 500))
nrow(subset(dm, dm$price < 250))
nrow(subset(dm, dm$price >= 15000))

# A função by leva como argumento outra função, neste caso, 'summary'
by(dm$price, dm$cut, summary)
help("by")
