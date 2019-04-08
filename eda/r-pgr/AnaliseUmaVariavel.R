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
  