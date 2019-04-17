options(repos='http://cran.rstudio.com/')
install.packages('ggplot2')
library(ggplot2)

dm <- diamonds

summary(dm)
str(dm)
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

# Utilização do faceting :: http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/
qplot(x = price, data = diamonds) + facet_wrap(~cut)

ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 85, color = 'black', fill = '#F79420') +
  coord_cartesian(xlim = c(0, 20000)) + 
  xlab('Preço dos diamantes') + 
  ylab('Contagem') +
  facet_wrap(~cut)

ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 85, color = 'black', fill = '#F79420') +
  coord_cartesian(xlim = c(0, 20000)) + 
  xlab('Preço dos diamantes') + 
  ylab('Contagem') +
  facet_wrap(~cut, scales = "free_y")

# Avaliar o uso recomendado de scale_x_log10
ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 0.025, color = 'black', fill = '#F79420') +
  scale_x_log10() 

# Você utiliza as variáveis de preço e quilate no parâmetro para x. Qual expressão 
# dá o preço por quilate? 
# Para distribuições de cauda longa, você pode adicionar a camada 
# ggplot assim como scale_x_log10() para transformar a variável.
ggplot(aes(x = price), data = dm) + 
  geom_histogram(binwidth = 0.025, color = 'black', fill = '#F79420') +
  scale_x_log10() + 
  xlab('Preço dos diamantes') + 
  ylab('Contagem') +
  facet_wrap(~cut, scales = "free_y")


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

# Boxplots para variáveis categóricas :: As variáveis categóricas ficam no eixo x
# enquanto as variáveis contínuas, no eixo y
ggplot(aes(x = dm$color, y = dm$price), data = dm) + 
  geom_boxplot() +
  xlab('Cor') +
  ylab('Preço')
  
ggplot(aes(x = dm$color, y = dm$price), data = dm) + 
  geom_boxplot() +
  scale_y_continuous(breaks = seq(0, 20000, 1000)) +
  xlab('Cor') +
  ylab('Preço')

by(dm$price, dm$color, summary)

ggplot(aes(x = dm$color, y = dm$price/dm$carat), data = subset(dm, dm$carat != 0)) + 
  geom_boxplot() +
  xlab('Cor') +
  ylab('Preço por quilate')

ggsave('/home/seabra/dev/dsjourney/eda/data/Boxplot_Cor_Preco_por_Quilate.png')

# Função que retorna o intervalo interquartil
IQR(subset(dm, dm$color == 'D')$price)
IQR(subset(dm, dm$color == 'J')$price)

ggplot(aes(x = dm$cut, y = dm$price), data = dm) + 
  geom_boxplot() +
  xlab('Tipo de corte') +
  ylab('Preço')

ggplot(aes(x = dm$clarity, y = dm$price), data = dm) + 
  geom_boxplot() +
  xlab('Brilho') +
  ylab('Preço')

ggplot(aes(x = dm$carat, y = dm$price), data = dm) + 
  geom_boxplot() +
  xlab('Brilho') +
  ylab('Preço')

# Polígono de frequencia
ggplot(aes(x = dm$carat), data = dm) + 
  geom_freqpoly(binwidth=0.1) +
  scale_x_continuous(breaks = seq(0, 7, 0.1)) +
  scale_y_continuous(breaks = seq(0, 12000, 1000))

str(dm)

# Cheatseets :: https://www.rstudio.com/resources/cheatsheets/

library(dplyr)
install.packages("devtools")
devtools::install_github("rstudio/EDAWR")

library(EDAWR)
