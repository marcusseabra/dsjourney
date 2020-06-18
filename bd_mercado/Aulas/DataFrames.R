
# DATA FRAMES

N = 3*4
df = data.frame(
  id = 1:N,
  data = rep(as.Date("2018-01-05") + (1:(N/3)), each = 3), # rep: repete as datas 3x cada
  nome = c("Acoes", "Juros", "Cambio"),                    # esse vetor sera reciclado
  saldo = 1000 + 10*runif(N),                              # runif: aleatorio uniforme de 0 a 1
  mtm = 1000 + 20*runif(N),
  stringsAsFactors = FALSE
)

# le pedacos do df
df[1,]
df[-2,]
df[,2]
df[,"saldo"]
df$saldo
df[1:5,]
df[1:3, 1:4]
df[df$saldo > 1001,]

# modificar um df
df[1,"nome"] = "Acoes2"
df[df$saldo > 1001,"saldo"] = 1001
df$classificacao = "DPV"
df$id = NULL

df2 = data.frame(
  data = as.Date("2018-01-10"),
  nome = "Acoes",
  saldo = 1010,
  mtm = 1020,
  classificacao = "MAV",
  stringsAsFactors = FALSE
)

df = rbind(df, df2)

df = df[df$nome == "Juros",]
