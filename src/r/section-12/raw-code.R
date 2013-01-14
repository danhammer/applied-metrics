library(ggplot2)
library(dtw)

random.data <- function(T = 100, alpha = 5) {
  t <- 1:T
  e0 <- rnorm(T, sd=0.25); e1 <- rnorm(T, sd=0.25)
  time.error <- sin(t/alpha)
  P <- ifelse(t > T/2, 1, 0)

  y0 <- 1 + time.error + e0
  y1 <- 3 + time.error + 0.5*P + e1

  data <- data.frame(rbind(cbind(y0, t, 0, P), cbind(y1, t, 1, P)))
  names(data) <- c("y", "t", "G", "P")
  return(data)
}

treatment.est <- function(df) {
  m <- lm(y ~ 1 + P + G + P*G, data=df)
  return(m$coefficients[["P:G"]])
}

df <- random.data(100)
plot(df$y[df$G == 0], type="l", ylim=c(-1, 6), ylab="y")
lines(df$y[df$G == 1], col="red")

treatment <- sapply(1:1000, function(x) {treatment.est(random.data())})
mean(treatment); sd(treatment)

png("raw-histogram.png", width=750)
hist(treatment, breaks = 20, col="grey", border="white", main="")
dev.off()

## lag.walk <- function(len) {
##   res <- rep(0,len)
##   l <- 0
##   for (i in 8:len) {
##     p <- rnorm(1)
##     if (p > -0.2)
##       { l <- l + 1 }
##     else
##       { l <- l - 1 }
##     if (l > 30)
##       {l <- 20}
##     else if (l < 0)
##       {l <- 0}
##     res[i] <- l
##   }
##   res
## }

alpha <- 5
t <- 1:100
e0 <- rnorm(T, sd=0.25); e1 <- rnorm(T, sd=0.25)
time.error <- sin(t/alpha)
P <- ifelse(t > T/2, 1, 0)
lags <- cumsum(rbinom(100, 1, p=0.1))
drift.error <- sin(t/(alpha + (2 * lags/max(lags))))
y0 <- 1 + time.error + e0
y1 <- 4 + drift.error + 0.5*P + e1


drift.data <- function(T = 100, alpha = 5) {
  t <- 1:T
  e0 <- rnorm(T, sd=0.25); e1 <- rnorm(T, sd=0.25)
  time.error <- sin(t/alpha)
  P <- ifelse(t > T/2, 1, 0)
  lags <- cumsum(rbinom(100, 1, p=0.1))
  drift.error <- sin(t/(alpha + (2 * lags/max(lags))))
  y0 <- 1 + time.error + e0
  y1 <- 4 + drift.error + 0.5*P + e1
  plot(y1, type = "l", col="red", lty=2, ylim=c(-1,6))
  lines(y0)
  data <- data.frame(rbind(cbind(y0, t, 0, P), cbind(y1, t, 1, P)))
  names(data) <- c("y", "t", "G", "P")
  return(data)
}

treatment <- sapply(1:1000, function(x) {treatment.est(drift.data())})
hist(treatment, breaks = 20, col="grey", border="white", main="")
mean(treatment)
sd(treatment)

warped.est <- function(df) {
  y0 <- df$y[df$G == 0]; y1 <- df$y[df$G == 1]
  align <- dtw(y1, y0, step.pattern=symmetricP2, open.end=TRUE)
  dtwPlotTwoWay(align, y1, y0)
  y0.match.val <- y0[align$index2]
  y1.match.val <- y1[align$index1]
  diff <- y1.match.val - y0.match.val
  diff.data <- data.frame(idx=align$index1, diff=diff)
  y1 <- y0 + aggregate(diff.data, by=list(diff.data$idx), FUN=mean)$diff
  df$y <- c(y0, y1)
  ## df <- df[df$t <= max(align$index2), ]
  m <- lm(y ~ 1 + P + G + P*G, data=df)
  print(m$coefficients[["P:G"]])
  return(m$coefficients[["P:G"]])
}

treatment <- sapply(1:1000, function(x) {warped.est(drift.data())})
hist(treatment, breaks = 20, col="grey", border="white", main="")
mean(treatment)
sd(treatment)

treatment.raw <- sapply(1:1000, function(x) {treatment.est(drift.data())})
treatment.warped <- sapply(1:1000, function(x) {warped.est(drift.data())})

warped <- data.frame(treatment = treatment.warped, method = "warped")
raw <- data.frame(treatment = treatment.raw, method = "standard")
hist.data <- data.frame(rbind(warped, raw))
(g <- ggplot(hist.data, aes(x=treatment, fill=method)) + geom_density(alpha=0.2))
ggsave("hist-estimate.png", g, width=8, height=4, dpi=200)

dd <- drift.data(100)
y0 <- dd$y[dd$G == 0]; y1 <- dd$y[dd$G == 1]
png("lines.png", width=750)
plot(y0, type="l", ylim=c(-1, 6), ylab="y", col="red", lty=2)
lines(y1)
dev.off()
align <- dtw(y1, y0, step.pattern=symmetricP2, open.end=TRUE)
png("dtw.png", width=750)
dtwPlotTwoWay(align, y1, y0, ylab="y")
dev.off()
y0.match.val <- y0[align$index2]
y1.match.val <- y1[align$index1]
graph.seq <- 1:max(align$index2)
diff <- y1.match.val - y0.match.val
diff.data <- data.frame(idx=align$index1, diff=diff)
y1.new <- y0 + aggregate(diff.data, by=list(diff.data$idx), FUN=mean)$diff
plot(y0, type="l", ylim=c(-1, 6), ylab="y")
lines(y1.new, col="red")
new.diff <- y1.new[graph.seq]-y0[graph.seq]
old.diff <- y1[graph.seq]-y0[graph.seq]
plot(new.diff, type="l", ylim=c(1, 6), col="red")
lines(old.diff)
mean(new.diff[51:max(align$index2)]) - mean(new.diff[1:50])
mean(old.diff[51:max(align$index2)]) - mean(old.diff[1:50])
