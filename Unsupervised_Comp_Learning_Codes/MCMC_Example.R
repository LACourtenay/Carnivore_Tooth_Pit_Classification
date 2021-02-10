# R Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# R Code for Augmentation of a Probability Distribution using Markov Chain Monte Carlos
# An Example for Univariate distributions

# Necessary libraries and functions -----------------------------

# Libraries for data visualization

library(ggplot2)
library(ggpubr)
library(gridExtra)

# Libraires for visualising probability distributions

library(sm)

# Libraries for Data Handling

library(tidyverse)

# Libraries for Skewed Probability Distributions (Where required)

library(sn)

# Libraries for Data Quality Evaluation

library(equivalence)

# Library for 

# Function for plots

add.alpha <- function(col, alpha=1){ # Function for setting the alpha of colours
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
          rgb(x[1], x[2], x[3], alpha=alpha))  
}

#

# Load Data -----------------------------

# Make sure to load data with the name a
# e.g.
# a<-read.table(file.choose(), sep = ",", head = TRUE)

target_sample_size <- 100
target_animal <- "Lion" # Select animal to augment
target_PC <- 1 # Select the PC Score you wish to augment

# Extract the distribution to augment

target<-as_tibble(a) %>%
  filter(Sample == target_animal) %>%
  dplyr::select(-Sample); target <- as.vector(target[,(target_PC)][[1]])

#

# Define Markov Chain Monte Carlo -----------------------------

# Characterise the distribution using robust metrics

mu = median(target)
st = mad(target, constant = 1.4826)

# Define MCMC for a single dimension

f = function(x) {dnorm(x, mean = mu, sd = st)}
q = function(x) {rnorm(1, x, 4)}
step = function(x, f, q) {
  xp = q(x)
  alpha = min(1, f(xp) / f(x))
  if(runif(1) < alpha) {x = xp}
  x
}
run = function(x, f, q, nsteps) {
  res<-matrix(NA, nsteps, length(x))
  for(i in seq_len(nsteps)){
    res[i, ] <- x <- step(x, f, q)
  }
  drop(res)
}

# Hyperparameters

iter = 50000 # Define the number of iterations. Recomended minimum 10,000
sd_metropolis_hastings = 0.3 # Define the metropolis hastings standard dev. parameter

# Run the MCMC

mcmc_results <- run(-1, f, function(x) rnorm(1, x,  sd_metropolis_hastings), iter)

# Trace Plots

X11(); ggarrange(ggplot(data = as.data.frame(mcmc_results), aes(x = mcmc_results)) +
                   geom_histogram(aes(y = ..density..), fill = "darkgrey", col = "black") +
                   geom_density(aes(y = ..density..), size = 1,
                                bw = 0.1,
                                col = "red") +
                   xlab("Values") +
                   ylab("Density") +
                   theme_bw() +
                   coord_cartesian(xlim = c(-1,1)) +
                   theme(axis.title = element_text(face = "bold", size = 15),
                         axis.title.x = element_text(margin = margin(t = 15, b = 10)),
                         axis.title.y = element_text(margin = margin(l = 15, r = 10)),
                         plot.margin = margin(t = 25, r = 25)),
                 ggarrange(ggplot(data = as.data.frame(mcmc_results), aes(x = seq(1:length(mcmc_results)), y = mcmc_results)) +
                             geom_line() +
                             xlab("Iterations") +
                             ylab("Values") +
                             theme_bw() +
                             theme(axis.title = element_text(face = "bold", size = 15),
                                   axis.title.x = element_text(margin = margin(t = 15, b = 20)),
                                   axis.title.y = element_text(margin = margin(l = 20, r = 15)),
                                   plot.margin = margin(t = 25)) +
                             coord_cartesian(ylim = c(-1,1)),
                           ggplot(data = as.data.frame(mcmc_results), aes(x = mcmc_results)) +
                             geom_density(size = 1, bw = 0.1) +
                             ylab("Density") +
                             theme_bw() +
                             theme(axis.text.y = element_blank(),
                                   axis.ticks = element_blank(),
                                   axis.title.x = element_text(face = "bold", size = 15),
                                   axis.title.y = element_blank(),
                                   plot.margin = unit(c(0,2,0,0), "cm")) +
                             rotate(xlim = c(-1,1)),
                           ncol = 2, nrow = 1, align = "hv",
                           widths = c(2,1)),
                 nrow = 2)

# Calculate and plot Autocorrelation

auto_cor_slow<-acf(mcmc_results, las=1, main="Small steps")$acf
ggplot(as.data.frame(auto_cor_slow), aes(x = seq(1:nrow(auto_cor_slow)), y = V1)) +
  geom_bar(stat = "identity", fill = "darkgrey", col = "black", width = 0.05) +
  geom_point(size = 4, color = "red") +
  geom_hline(yintercept = 0.025, col = "blue", linetype = "longdash") +
  geom_hline(yintercept = -0.025, col = "blue", linetype = "longdash") +
  ggtitle("Standard Deviation = 0.3") +
  xlab("Lag") +
  ylab("Autocorrelation Function") +
  theme_bw() +
  theme(axis.title = element_text(face = "bold"),
        axis.title.x = element_text(margin = margin(t = 15, b = 20)),
        axis.title.y = element_text(margin = margin(l = 20, r = 15)),
        plot.title = element_text(size = 15, face = "bold", margin = margin(b = 10, t = 10)))

# Calculate ESS value

coda::effectiveSize(mcmc_results)

# Evaluate general performance of MCMC

res_sample<-mcmc_results[(length(mcmc_results)/2):length(mcmc_results)] # exclude a burnout period
res_sample<-res_sample[!duplicated(res_sample)] # remove repeated values
res_sample<-as_tibble(res_sample) %>%
  filter(value > -1 & value < 1); res_sample<-res_sample$value
res_sample<-sample(res_sample,
                   size = length(target),
                   replace = FALSE)  # extract a final sample

# Visualize augmented data

sm.density(target, xlim = c(-1, 1)) # visualise the original data
sm.density(res_sample, add = TRUE, col = "red") # visualise the augmented data

# Calculate equivalence of augmented data

abs(rtost(target, res_sample, alpha = 0.05)$mean.diff)
rtost(target, res_sample, alpha = 0.05)$p.value

# Final augmentation -----------------------------

# Create final dataset by augmenting the dataset to the target sample size

aug_sample<-mcmc_results[(length(mcmc_results)/2):length(mcmc_results)]; aug_sample<-aug_sample[!duplicated(aug_sample)]
aug_sample<-as_tibble(aug_sample) %>%
  filter(value > -1 & value < 1); aug_sample<-aug_sample$value
aug_sample<-sample(aug_sample,
                   size = target_sample_size-length(target),
                   replace = FALSE)

# Compare original data with final augmented data

compare<-rbind(data.frame(res = c(aug_sample, target), data_type = "Augment"),
               data.frame(res = target, data_type = "Original"))

X11(); ggplot(data = compare, aes(x = res, color = data_type, fill = data_type)) +
  geom_histogram(aes(y = ..density..), alpha = 0.25, bins = 15) +
  theme_bw() +
  xlab("Values") +
  ylab("Density") +
  labs(fill = "Std Dev", colour = "Std Dev") +
  scale_colour_manual(values = c("black", "red")) +
  scale_fill_manual(values = c("black", "red")) +
  coord_cartesian(xlim = c(-1,1)) +
  theme(axis.title = element_text(face = "bold", size = 15),
        axis.title.x = element_text(margin = margin(t = 15, b = 10)),
        axis.title.y = element_text(margin = margin(l = 15, r = 10)),
        plot.margin = margin(t = 25, r = 25),
        legend.title = element_text(face = "bold", margin = margin(b = 5), size = 15),
        legend.text = element_text(size = 15, face = "bold"),
        legend.key.size = unit(1, "cm"))

#
