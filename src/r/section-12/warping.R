library(dtw)
library(TTR)
library(ggplot2)

lag.walk <- function(len) {
  res <- rep(0,len)
  l <- 0
  for (i in 8:len) {
    p <- rnorm(1)
    if (p > -0.25)
      { l <- l + 1 }
    else
      { l <- l - 1 }
    if (l > 30)
      {l <- 20}
    else if (l < 0)
      {l <- 0}
    res[i] <- l
  }
  res
}

f <- 10

B <- 100
n <- 300
x <- 1:n
a0 <- sin(x/f)

treatment.raw    <- rep(-9999,B)
treatment.warped <- rep(-9999,B)

for (i in 1:B) {

  e0 <- rnorm(n, sd=0.2)
  e1 <- rnorm(n, sd=0.2)

  persist <- function(i) {
    old.series <- sin(x/f)
    mean(old.series[(i - lags[i]):i])
  }
  
  lags <- lag.walk(n)
  a1 <- sin(x/(f + (1.5 * lags/max(lags))))
  ## a1 <- sapply(1:n, persist)
  ## scale <- sin(0.25*x/f) + 1
  ## norm.scale <- f + (scale/max(scale) * 1)
  ## a1 <- sin(x/norm.scale)
  
  t <- ifelse(x <= n/2, 0, 1)
  
  y0 <- 1 + a0 + e0
  y1 <- 3.5 + 2*a1 + t + e1
  
  data.raw <- data.frame(rbind(cbind(y0, 0, t), cbind(y1, 1, t)))
  names(data.raw) <- c("val", "id", "post")
  m <- lm(val ~ id*post, data=data.raw)
  treatment.raw[i] <- m$coefficients[["id:post"]]
  
  d <- dtw(y0, y1, step.pattern=symmetricP2)
  dtwPlotTwoWay(d, y0, y1)
  
  y0.warped <- y0[d$index1]
  y1.warped <- y1[d$index2]
  diff <- y1.warped - y0.warped
  df <- data.frame(idx=d$index1, diff=diff)
  warped.diff <- aggregate(df, by=list(df$idx), FUN=mean)$diff
  
  data.warped <- data.frame(rbind(cbind(y0, 0, t), cbind(y0 + warped.diff, 1, t)))
  names(data.warped) <- c("val", "id", "post")
  m <- lm(val ~ id*post, data=data.warped)
  treatment.warped[i] <- m$coefficients[["id:post"]]
}

warped <- data.frame(treatment = treatment.warped, method = "warped")
raw <- data.frame(treatment = treatment.raw, method = "raw")
hist.data <- data.frame(rbind(warped, raw))

(g <- ggplot(hist.data, aes(x=treatment, fill=method)) + geom_density(alpha=0.2))
ggsave("treat-hist2.png", g)



## f <- 10
## B <- 1000
## n <- 200
## x <- 1:n
## a0 <- sin(x/f)
## e0 <- rnorm(n, sd=0.2)
## e1 <- rnorm(n, sd=0.2)  

## lags <- lag.walk(n)
## a1 <- sapply(1:n, persist)

## scale <- sin(0.25*x/f) + 1
## norm.scale <- f + (scale/max(scale) * 2)
## a1 <- sin(x/norm.scale)

## lags <- lag.walk(n)
## a1 <- sin(x/(f + (2 * lags/max(lags))))

## t <- ifelse(x <= n/2, 0, 1)
## y0 <- 1 + a0 + e0
## y1 <- 3 + a1 + 0.5 * t + e1
## plot(a0, type="l", ylim=c(-2,2))
## lines(a1, col="red")

n <- 100
smoothed.lags <- 12
B <- 100
treatment.raw    <- rep(-9999,B)
treatment.warped <- rep(-9999,B)

for (i in 1:B) {
  ar3 <- na.omit(SMA(rnorm(n, sd=4), n=smoothed.lags))
  e0 <- rnorm(n-smoothed.lags+1, sd=0.3)
  e1 <- rnorm(n-smoothed.lags+1, sd=0.3)
  t <- ifelse(smoothed.lags:n > n/2, 1, 0)
  y0 <- na.omit(1 + ar3 + e0)
  y1 <- na.omit(6 + ar3 + t + e1)
  data.raw <- data.frame(rbind(cbind(y0, 0, t), cbind(y1, 1, t)))
  names(data.raw) <- c("val", "id", "post")
  m <- lm(val ~ id*post, data=data.raw)
  treatment.raw[i] <- m$coefficients[["id:post"]]
  d <- dtw(y0, y1, step.pattern=symmetricP1)
  dtwPlotTwoWay(d, y0, y1)  
  y0.warped <- y0[d$index1]
  y1.warped <- y1[d$index2]
  diff <- y1.warped - y0.warped
  df <- data.frame(idx=d$index1, diff=diff)
  warped.diff <- aggregate(df, by=list(df$idx), FUN=mean)$diff
  data.warped <- data.frame(rbind(cbind(y0, 0, t), cbind(y0 + warped.diff, 1, t)))
  names(data.warped) <- c("val", "id", "post")
  m <- lm(val ~ id*post, data=data.warped)
  treatment.warped[i] <- m$coefficients[["id:post"]]
}

warped <- data.frame(treatment = treatment.warped, method = "warped")
raw <- data.frame(treatment = treatment.raw, method = "raw")
hist.data <- data.frame(rbind(warped, raw))
(g <- ggplot(hist.data, aes(x=treatment, fill=method)) + geom_density(alpha=0.2))

plot(y0, type="l", ylim=c(-1,6))
lines(y1, col="red")

