# R Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# R Code for Sample Size Experiments and the Central Limit Theorem Check

# Necessary libraries and functions -----------------------------

# Package for Density Plots
library(sm)

# Package for Skew and Kurtosis calculation values
library(e1071)

# Package for generating skewed theoretical probability distributions
library(sn)

# BFB Function

BFB<-function(p){
  return((1/(-exp(1)*p*log(p))))
}

#

# Sample Size Experiments -----------------------------

# NOTE !!!!!!
# Functions are stochastic - every iteration of this code will produce different results, be sure
# to set a seed if reproducibility is required. e.g. set.seed(12345)

# Create 4 datasets of varying sizes, all sampled from a Gaussian distribution

X_10<-rnorm(10, mean = 0, sd = 1)
Y_10<-rnorm(10, mean = 0, sd = 1)
X_50<-rnorm(50, mean = 0, sd = 1)
Y_50<-rnorm(50, mean = 0, sd = 1)
X_100<-rnorm(100, mean = 0, sd = 1)
Y_100<-rnorm(100, mean = 0, sd = 1)
X_1000<-rnorm(1000, mean = 0, sd = 1)
Y_1000<-rnorm(1000, mean = 0, sd = 1)

# Descriptive Statistics for samples -----------------------------

# Normality Tests - Shapiro W

shapiro.test(X_10)$statistic
shapiro.test(X_50)$statistic
shapiro.test(X_100)$statistic
shapiro.test(X_1000)$statistic

# Normality Tests - Shapiro p

shapiro.test(X_10)$p.value
shapiro.test(X_50)$p.value
shapiro.test(X_100)$p.value
shapiro.test(X_1000)$p.value

# Normality Tests - Shapiro BFB (Note if p-value is over 0.3681 then BFB is against Ha)

BFB(shapiro.test(X_10)$p.value)
BFB(shapiro.test(X_50)$p.value)
BFB(shapiro.test(X_100)$p.value)
BFB(shapiro.test(X_1000)$p.value)

# Mean

mean(X_10)
mean(X_50)
mean(X_100)
mean(X_1000)

# Median

median(X_10)
median(X_50)
median(X_100)
median(X_1000)

# Standard Deviation

sd(X_10)
sd(X_50)
sd(X_100)
sd(X_1000)

# Normalized Median Absolute Deviation

mad(X_10, constant = 1.4826)
mad(X_50, constant = 1.4826)
mad(X_100, constant = 1.4826)
mad(X_1000, constant = 1.4826)

# Skewness

skewness(X_10)
skewness(X_50)
skewness(X_100)
skewness(X_1000)

# Kurtosis

kurtosis(X_10)
kurtosis(X_50)
kurtosis(X_100)
kurtosis(X_1000)

#

# Plots -----------------------------

par(mfrow = c(2,4), mar = c(5.1, 5, 4.1, 2.))

sm.density(X_10, lwd = 2, xlim = c(-5,5), ylim = c(0, 0.5), xlab = "", ylab = "")
plot(function(x) {dnorm(x, mean = 0, sd = 1)}, from =-5, to = 5,
     add = TRUE, lwd = 2, col = "red", lty = 2)
mtext(side = 1, line = 3, "X_10", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Probability Density Function", cex = 1.25, font = 2)
sm.density(X_50, lwd = 2, xlim = c(-5,5), ylim = c(0, 0.5), xlab = "", ylab = "")
plot(function(x) {dnorm(x, mean = 0, sd = 1)}, from =-5, to = 5,
     add = TRUE, lwd = 2, col = "red", lty = 2)
mtext(side = 1, line = 3, "X_50", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Probability Density Function", cex = 1.25, font = 2)
sm.density(X_100, lwd = 2, xlim = c(-5,5), ylim = c(0, 0.5), xlab = "", ylab = "")
plot(function(x) {dnorm(x, mean = 0, sd = 1)}, from =-5, to = 5,
     add = TRUE, lwd = 2, col = "red", lty = 2)
mtext(side = 1, line = 3, "X_100", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Probability Density Function", cex = 1.25, font = 2)
sm.density(X_1000, lwd = 2, xlim = c(-5,5), ylim = c(0, 0.5), xlab = "", ylab = "")
plot(function(x) {dnorm(x, mean = 0, sd = 1)}, from =-5, to = 5,
     add = TRUE, lwd = 2, col = "red", lty = 2)
mtext(side = 1, line = 3, "X_1000", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Probability Density Function", cex = 1.25, font = 2)
plot(X_10, Y_10, pch = 19, cex = 1, xlim = c(-5, 5), ylim = c(-5, 5), asp = 1,
     xlab = "", ylab = "")
mtext(side = 1, line = 3, "X_10", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Y_10", cex = 1.25, font = 2)
plot(X_50, Y_50, pch = 19, cex = 1, xlim = c(-5, 5), ylim = c(-5, 5), asp = 1,
     xlab = "", ylab = "")
mtext(side = 1, line = 3, "X_50", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Y_50", cex = 1.25, font = 2)
plot(X_100, Y_100, pch = 19, cex = 1, xlim = c(-5, 5), ylim = c(-5, 5), asp = 1,
     xlab = "", ylab = "")
mtext(side = 1, line = 3, "X_100", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Y_100", cex = 1.25, font = 2)
plot(X_1000, Y_1000, pch = 19, cex = 1, xlim = c(-5, 5), ylim = c(-5, 5), asp = 1,
     xlab = "", ylab = "")
mtext(side = 1, line = 3, "X_1000", cex = 1.25, font = 2)
mtext(side = 2, line = 3, "Y_1000", cex = 1.25, font = 2)

par(mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1))

#

# Example of Central Limit Theorem Using Skewed Distribution -----------------------------

# Plot theoretical skewed gaussian distribution

plot(function(x){dsn(x, xi = 0, omega = 1, alpha = 5)}, lwd = 2, xlim = c(-1, 5),
     col = "red", lty = 2,
     main = "Example of Non-Gaussian Distribution")

# Sample points from said distribution and plot them on graph

example_skewed_x = rsn(100, xi = 0, omega = 1, alpha = 5)
to_plot<-data.frame(x = example_skewed_x, y = 0)
points(to_plot, pch = 19, col = "black")
sm.density(example_skewed_x, add = TRUE, lwd = 2)

# Calcualte Normality of non-normal distribution

shapiro.test(example_skewed_x)$statistic # W Value
shapiro.test(example_skewed_x)$p.value # P-Value
BFB(shapiro.test(example_skewed_x)$p.value) # BFB

# Describe the non-normal distribution

mean(example_skewed_x)
median(example_skewed_x)
sd(example_skewed_x)
mad(example_skewed_x, constant = 1.4826)
skewness(example_skewed_x)
kurtosis(example_skewed_x)

# Sample from distribution to converge on a gaussian distribution

perm_size = 300
sample_size = 28

central_limit_theorem_check <- c()
for(i in 1:perm_size) {
  data<-example_skewed_x[sample(length(example_skewed_x), size = sample_size, replace = FALSE)]
  central_limit_theorem_check <- c(central_limit_theorem_check, mean(data))
}

# Calcualte Normality of the permuted values

shapiro.test(central_limit_theorem_check)$statistic # W Value
shapiro.test(central_limit_theorem_check)$p.value # P-Value
BFB(shapiro.test(central_limit_theorem_check)$p.value) # BFB

# Describe the permuted values

mean(central_limit_theorem_check)
median(central_limit_theorem_check)
sd(central_limit_theorem_check)
mad(central_limit_theorem_check, constant = 1.4826)
skewness(central_limit_theorem_check)
kurtosis(central_limit_theorem_check)

# Plot density and qq-plots

par(mfrow = c(2,2))
sm.density(example_skewed_x, lwd = 2)
sm.density(central_limit_theorem_check, lwd = 2)
qqnorm(example_skewed_x, pch = 19, frame = FALSE, main = "Original")
qqline(example_skewed_x, col = "red", lwd  = 2)
qqnorm(central_limit_theorem_check, pch = 19, frame = FALSE, main = "Central Limit Theorem")
qqline(central_limit_theorem_check, col = "red", lwd  = 2)
par(mfrow = c(1,1))

#
