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
