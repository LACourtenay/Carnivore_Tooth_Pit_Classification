# R Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# R Code for the calculation of Bayes Factor Callibrations, Bayes Factor Bounds and False Positive Risks
# Additional code used for the plotting of calibration curves

# Bayes Factor Callibrations, Bayes Factor Bounds and False Positive Risk functions -----------------------------

B_p<-function(p){
  return(-exp(1)*p*log(p))
}

B_a<-function(p){
  return((1+(-exp(1)*p*log(p))^(-1))^(-1))
}

BFB<-function(p){
  return((1/(-exp(1)*p*log(p))))
}

p_BFB<-function(p){
  return((1/(-exp(1)*p*log(p)))/(1+(1/(-exp(1)*p*log(p)))))
}

post_odds<-function(p, priors = 0.5){
  pH = priors/(1-priors)
  return(0.5 * (BFB(p)*pH))
}

FPR<-function(p, priors = 0.5){
  pH = priors/(1-priors)
  return(1/(1+(pH*BFB(p))))
}

p_BFB_w_Priors<-function(p, priors = 0.5){
  pH = priors/(1-priors)
  FPR_value = FPR(p)
  return(
    (1-FPR_value)/(1-FPR_value+(pH*FPR_value))
  )
}

# Adaptation

p_H0<-function(p, priors = 0.5){
  if(p <= 0.3681) {
    value = FPR(p, priors = priors)
  } else {
    value = 1-FPR(p, priors = 1-priors)
  }
  values<-list("decimal_value" = value, "percentage" = value*100)
  return(values)
}; p_H0<-Vectorize(p_H0)

#

# Using Functions for p-Value Calibrations ------------------------------

# Bayes Factor Bounds

BFB(0.1)
BFB(0.05)
BFB(0.01)
BFB(0.005)
BFB(0.003)

# Returning BFB in a scientific number format

formatC(BFB(0.0000001), format = "e", digits = 1)

# Bayes Factor Bounds as a percentage

p_BFB(0.1)
p_BFB(0.05)
p_BFB(0.01)
p_BFB(0.005)
p_BFB(0.003)

# Posterior Odds of Bayes Factor Bounds

post_odds(0.1)
post_odds(0.05)
post_odds(0.01)
post_odds(0.005)
post_odds(0.003)

# False Positive Risk

FPR(0.1)
FPR(0.05)
FPR(0.01)
FPR(0.005)
FPR(0.003)

# or

FPR(0.1, priors = 0.5)
FPR(0.05, priors = 0.5)
FPR(0.01, priors = 0.5)
FPR(0.005, priors = 0.5)
FPR(0.003, priors = 0.5)

# Bayes Factor Bounds with Priors (Inverse of FPR)

p_BFB_w_Priors(0.1, priors = 0.5)
p_BFB_w_Priors(0.05, priors = 0.5)
p_BFB_w_Priors(0.01, priors = 0.5)
p_BFB_w_Priors(0.005, priors = 0.5)
p_BFB_w_Priors(0.003, priors = 0.5)

#

# p-Value and Bayes Factor Calibrations ------------------------------

par(mar = c(5.1, 5, 4.1, 2.))

plot(function(x) {-exp(1) * x * log(x)},
     xlim = rev(c(0.00001,0.1)), lwd = 2,
     main = "Bayes Factor and P-Value Calibrations",
     xlab = "", ylab = "", cex.main = 2, xaxt = "none", yaxt = "none")
mtext(side = 1, line = 3, "p-value", cex = 1.5, font = 2); mtext(side = 2, line = 3, "Bayes Factor", cex = 1.5, font = 2)
axis(1, rev(seq(0, 0.1, 0.02)), font = 1, cex.axis = 1.25); axis(2, seq(0, 0.7, 0.2), font = 1, cex.axis = 1.25)
plot(function(x) {(1+(-exp(1) * x * log(x))^(-1))^(-1)}, xlim = rev(c(0.00001,0.1)),
     lwd = 2, add = TRUE, col = "red")
abline(v = 0.05, lwd = 2, lty = 5, col = "dark grey")
abline(v = 0.005, col = "dark grey", lwd = 2, lty = 5)

par(mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1))

#

# Bayes Factor Bound Callibration Curves ------------------------------

par(mar = c(5.1, 5, 4.1, 2.))

plot(function(x) {BFB(x)},
     xlim = rev(c(0.001,0.1)), lwd = 2,
     main = "Bayes Factor Bound Calibrations",
     xlab = "", ylab = "", cex.main = 2, xaxt = "none", yaxt = "none")
mtext(side = 1, line = 3, "p-value", cex = 1.5, font = 2); mtext(side = 2, line = 3, "BFB", cex = 1.5, font = 2)
axis(1, rev(seq(0, 0.1, 0.02)), font = 1, cex.axis = 1.25); axis(2, seq(0, 60, 20), font = 1, cex.axis = 1.25)
abline(v = 0.05, lwd = 2, lty = 5, col = "dark grey")
abline(v = 0.005, lwd = 2, lty = 5, col = "dark grey")

par(mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1))

#

# Finding point of maximal curvature ------------------------------

a<-seq(0.0001, 1, 0.001) # Generate a sequence of numbers
values<-BFB(a) # Calculate BFB values for each of the numbers in a sequence
for (i in 1:length(values)) {
  if(round(values[i], 6) == 1) {
    max_value <- a[i] # Find and save the value where BFB no longer decreases
    print(max_value)
    } # Print out this value
}

#

# Plotting BFB and FPR (Priors = 0.5) Calibration curve ------------------------------

par(mfrow = c(2,1), mar = c(5.1, 5.1, 2, 2.1))

plot(function(x){BFB(x)},
     xlim = rev(c(0.001, 1)), xlab = "", ylab = "",
     xaxt = "n", yaxt = "n",
     lwd = 2, main = "")
abline(v = max_value, col = "grey")
mtext("p-Value", side = 1, line = 3, font = 2)
mtext("Bayes Factor Bound", side = 2, line = 3, font = 2)
axis(1, at = seq(0, 1, 0.1))
axis(2, at = seq(0, 60, 10))
text(x = 0.29, y = 50, "p = 0.3681", col = "red", font = 2)
plot(function(x){FPR(x)},
     xlim = rev(c(0.001, 1)), ylim = c(0, 1),
     lwd = 2, main = "", yaxt = "n", xaxt = "n",
     xlab = "", ylab = "")
plot(function(x){p_BFB(x)}, from = 0.001, to = 1,
     add = TRUE, lwd = 2, col = "red")
abline(v = max_value, col = "grey")
mtext("p-Value", side = 1, line = 3, font = 2)
mtext("Probability", side = 2, line = 3, font = 2)
axis(1, at = seq(0, 1, 0.1))
axis(2, at = seq(0, 1, 0.1))

par(mfrow = c(1,1), mar = c(5.1, 4.1, 4.1, 2.1))

#

# Plotting Different Prior Probabilities ------------------------------

plot_functions<-function(prior_exp){
  plot(function(x){p_BFB_w_Priors(x, priors = prior_exp)},
       xlim = rev(c(0.0001,1)), ylim = c(0,1),
       col = "red", lwd = 2,
       asp = 1,
       xaxt = "n", yaxt = "n",
       xlab = "", ylab = "")
  plot(function(x){FPR(x, priors = prior_exp)},
       from = 1, to = 0.0001,
       col= "black", lwd = 2,
       add = TRUE)
  abline(v = 0.3681, col = "grey")
  mtext(paste("Prior Prob.: ", prior_exp*100, "%", sep = ""),
        side = 3, line = 1, cex = 1.5, font = 2)
  mtext("p-Value", side = 1, line = 3, font = 2)
  mtext("Probability", side = 2, line = 3, font = 2)
  axis(1, at = seq(0, 1, 0.1))
  axis(2, at = seq(0, 1, 0.1))
}

par(mfrow = c(1, 3), mar = c(5.1, 5.1, 5, 2.1))

plot_functions(0.8)
plot_functions(0.5)
plot_functions(0.2)

par(mfrow = c(1, 1), mar = c(5.1, 4.1, 4.1, 2.1))

#
