# R Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# R Code for plotting ReLU, Sigmoid and Swish activation functions alongside their derivatives

# Necessary libraries ----------

library(ggplot2)
library(gridExtra)

#

# Activation Functions and their Derivatives ------------------------------

# ReLU

relu <- function(x) {max(0, x)}
relu_g <- Vectorize(relu)
relu_d1<-function(x) {if(x < 0) {0} else {1}}
relu_d1_g <- Vectorize(relu_d1)

# Sigmoid

sigmoid <- function(x) (1/(1+exp(-x)))
sigmoid_g <- Vectorize(sigmoid)
sigmoid_d1 <- function(x) {}
sigmoid_d2<-function(x) {}
body(sigmoid_d1) <- D(body(sigmoid), "x")
body(sigmoid_d2) <- D(body(sigmoid_d1), "x")

# Swish

swish <- function(x) (x * (1/(1+exp(-x))))
swish_d1 <- function(x) {}
swish_d2<-function(x) {}
body(swish_d1) <- D(body(swish), "x")
body(swish_d2) <- D(body(swish_d1), "x")

#

# Print Derivative Formulae ------------------------------

# ReLU
print(relu_d1)
# Second Derivative = 0

# Sigmoid
print(sigmoid_d1)
print(sigmoid_d2)

# Swish
print(swish_d1)
print(swish_d2)

#

# Base R Plot ------------------------------

par(mfrow = c(1,3), mar = c(5.1, 5, 4.1, 2.))

curve(relu_g(x),
      xlim = c(-7,7), ylim = c(-0.1,2), # asp = 1,
      lwd = 3, xlab = "", ylab = "", main = "ReLU Activation Function",
      cex.main=2, xaxt="none", yaxt="none"
); abline(h = 0,
          lty = 2,
          col = "grey"); abline(v = 0,
                                lty = 2,
                                col = "grey")
mtext(side = 1, line = 3, "X", cex = 1.25, font = 2); mtext(side = 2, line = 3, "Y", cex = 1.25, font = 2)
axis(1, seq(-7, 7, 2), font = 1, cex.axis = 1.5); axis(2, seq(0, 2, 0.5), font = 1, cex.axis = 1.5)
curve(relu_d1_g(x), lwd = 3, col = "red", add = TRUE)
abline(h = 0, lwd = 3, col = "blue") # ReLU_d2

curve(sigmoid(x),
      xlim = c(-7,7), ylim = c(-0.1,1.1), # asp = 1,
      lwd = 3, xlab = "", ylab = "", main = "Sigmoid Activation Function",
      cex.main=2, xaxt="none", yaxt="none"
); abline(h = 0, lty = 2, col = "grey"); abline(v = 0, lty = 2, col = "grey")
mtext(side = 1, line = 3, "X", cex = 1.25, font = 2); mtext(side = 2, line = 3, "Y", cex = 1.25, font = 2)
axis(1, seq(-7, 7, 2), font = 1, cex.axis = 1.5); axis(2, seq(0, 1, 0.2), font = 1, cex.axis = 1.5)
plot(function(x){sigmoid_d1(x)}, from = -7, to = 7,
     lwd = 3, col = "red", add = TRUE)
plot(function(x){sigmoid_d2(x)}, from = -7, to = 7,
     lwd = 3, col = "blue", add = TRUE)

curve(swish(x),
      xlim = c(-7,7), ylim = c(-0.25,1.4), # asp = 1,
      lwd = 3, xlab = "", ylab = "", main = "Swish Activation Function",
      cex.main=2, xaxt="none", yaxt="none"
); abline(h = 0, lty = 2, col = "grey"); abline(v = 0, lty = 2, col = "grey")
mtext(side = 1, line = 3, "X", cex = 1.25, font = 2); mtext(side = 2, line = 3, "Y", cex = 1.25, font = 2)
axis(1, seq(-7, 7, 2), font = 1, cex.axis = 1.5); axis(2, seq(-0.2, 4, 0.2), font = 1, cex.axis = 1.5)
plot(function(x){swish_d1(x)}, from = -7, to = 7,
     lwd = 3, col = "red", add = TRUE)
plot(function(x){swish_d2(x)}, from = -7, to = 7,
     lwd = 3, col = "blue", add = TRUE)

par(mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1))

#

# Alternative GGPlot Option ------------------------------

plot_line_width = 1.25; plot_margin_values = c(0,0.5,0,0); plot_theme<-theme_bw() +
  theme(axis.title = element_text(face = "bold", size = 20),
        axis.text = element_text(size = 15),
        axis.title.x = element_text(margin = margin(t = 15, b = 15)),
        axis.title.y = element_text(margin = margin(l = 15, r = 15)),
        plot.title = element_text(margin = margin(t = 15, b = 15),
                                  size = 20, face = "bold"),
        plot.margin = unit(plot_margin_values, "cm")); relu_plot<-ggplot(data = data.frame(x = 0),
                                                                         mapping = aes(x = x)) +
  geom_hline(yintercept = 0, size = plot_line_width, color = "blue") +
  stat_function(fun = relu_g, size = plot_line_width) +
  stat_function(fun = relu_d1_g, size = plot_line_width, color = "red") +
  xlim(-7, 7) +
  ylim(-0.1, 2) +
  ggtitle("ReLU") +
  plot_theme; sigmoid_plot<-ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
  stat_function(fun = sigmoid_g, size = plot_line_width) +
  stat_function(fun = sigmoid_d1, size = plot_line_width, color = "red") +
  stat_function(fun = sigmoid_d2, size = plot_line_width, color = "blue") +
  xlim(-7, 7) +
  ylim(-0.1, 1.1) +
  ggtitle("Sigmoid") +
  plot_theme; swish_plot<-ggplot(data = data.frame(x = 0), mapping = aes(x = x)) +
  stat_function(fun = swish, size = plot_line_width) +
  stat_function(fun = swish_d1, size = plot_line_width, color = "red") +
  stat_function(fun = swish_d2, size = plot_line_width, color = "blue") +
  xlim(-7, 7) +
  ylim(-0.3, 2) +
  ggtitle("Swish") +
  theme_bw() +
  theme(axis.title = element_text(face = "bold", size = 20),
        axis.text = element_text(size = 15),
        axis.title.x = element_text(margin = margin(t = 15, b = 15)),
        axis.title.y = element_text(margin = margin(l = 15, r = 15)),
        plot.title = element_text(margin = margin(t = 15, b = 15),
                                  size = 20, face = "bold"),
        plot.margin = unit(c(0,1,0,0), "cm")); grid.arrange(relu_plot, sigmoid_plot, swish_plot, ncol = 3)

#
