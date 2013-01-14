
c <- 0.5; N <- 10000
X <- runif(N)
D <- ifelse(X > c, 1, 0)
Y <- 1 + X + 2*D + rnorm(N, sd = 0.5)

b <- 0.05
lower <- X < c & X > c - b
upper <- X > c & X < c + b

length(c(which(upper), which(lower)))

mean(Y[upper]) - mean(Y[lower])

g <- 0.5; gamma <- ifelse(X > c, 1, 0) + rnorm(N)
D <- ifelse(gamma > g, 1, 0)
Y <- 1 + X + 2*D + rnorm(N, sd = 0.5)

(mean(Y[upper]) - mean(Y[lower])) / (mean(D[upper]) - mean(D[lower]))

sim.fn <- function(repitition, c = 0.5, b = 0.05, g = 0.5, N = 10000) {
  X <- runif(N)
  gamma <- ifelse(X > c, 1, 0) + rnorm(N)
  D <- ifelse(gamma > g, 1, 0)
  Y <- 1 + X + 2*D + rnorm(N, sd = 0.5)
  lower <- X < c & X > c - b
  upper <- X > c & X < c + b
  (mean(Y[upper]) - mean(Y[lower])) / (mean(D[upper]) - mean(D[lower]))
}

png(filename="fuzz.png",height=400,width=700)
x <- sapply(1:1000, sim.fn)
hist(x, xlab = "", border = "grey", col = "grey", breaks = 40, main = "")
dev.off()
