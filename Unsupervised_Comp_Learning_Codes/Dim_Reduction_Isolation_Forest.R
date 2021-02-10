# R Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# R Code for Dimensionality Reduction and Anomaly Detection

# Necessary libraries and functions -----------------------------

# Libraries for geometric morphometrics

library(geomorph)
library(shapes)

# Libraries for data visualization

library(ggplot2)
library(ggpubr)
library(gridExtra)

# Libraries for Data Handling

library(tidyverse)

# Library for Isolation Forest

library(solitude)

# Function for plots

add.alpha <- function(col, alpha=1){ # Function for setting the alpha of colours
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
          rgb(x[1], x[2], x[3], alpha=alpha))  
}

# Rescaling function

ReScale <- function(x,first,last){(last-first)/(max(x)-min(x))*(x-min(x))+first}

#

# Load Landmark Data and Perform Procrustes Fit -----------------------------

a<-read.morphologika(file.choose()) # Load landmark data

GPAform<-procGPA(a$coords, scale = FALSE) # Procrustes fit excluding scaling procedure

train_data<-data.frame(Sample = a$labels, GPAform$scores[,1:5]) # Extract relevant PC Scores for processing

#

# Train Isolation Forest -----------------------------

iforest = isolationForest$new(sample_size = nrow(train_data),
                              num_trees = 100,
                              replace = FALSE,
                              seed = 666) # Define Isolation Forest Model

iforest$fit(train_data) # Train Isolation Forest

results = iforest$predict(train_data)
score = data.frame(score = results$anomaly_score) # Extract Anomaly Scores

threshold = 0.65 # Define a threshold for the Anomaly Scores - This number may need to be adjusted according
                    # to analyst's needs

# Clean dataset

final<-as_tibble(train_data) %>% mutate(score = score$score) %>%
  mutate(anom = if_else(
    score > threshold, "TRUE", "FALSE"
  )) %>%
  mutate(anom = as.factor(anom))
final$anom<-factor(final$anom, levels = c("TRUE", "FALSE"))

#

# Visualize Results -----------------------------

grid.arrange(ggplot(data = final, aes(x = score)) +
               geom_vline(xintercept = 0.55, size = 0.5, colour = NA) +
               geom_vline(xintercept = threshold, size = 0.75, colour = "red") +
               geom_density(size = 1) +
               theme_bw() +
               labs(title = "Distribution of Anomaly Scores") +
               xlab("Anomaly Score") +
               ylab("Density") +
               theme(
                 plot.margin = unit(c(0.5,2,0.5,0.5), "cm"),
                 axis.title = element_text(face = "bold"),
                 title = element_text(face = "bold")
               ),
             ggplot(data = final, aes(x = PC1, y = PC2)) +
               xlab("PC1") +
               ylab("PC2") +
               theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.background = element_blank(),
                     plot.title = element_blank(),
                     panel.border = element_rect(colour = "black", fill = NA),
                     axis.ticks.x = element_blank(),
                     axis.ticks.y = element_blank(),
                     axis.text = element_text(face = "bold"),
                     #axis.text.y = element_text(size = 10, margin = margin(t = 0, b = 0, r = 0, l = 1)),
                     #axis.text.x = element_text(size = 10, margin = margin(t = 1, b = 0, r = 0, l = 0)),
                     plot.margin = unit(c(1,1,1,1), "cm")
                     #axis.title.x = element_text(face = "bold", margin = margin(t = 10, r = 0, b = 5, l = 0)),
                     #axis.title.y = element_text(face = "bold", margin = margin(t = 0, r = 5, b = 0, l = 0))) +
               ) +
               stat_density_2d(geom = "raster", aes(fill = after_stat(density)),
                               contour = FALSE) +
               scale_fill_continuous(type = "viridis"),
             nrow = 1, ncol = 2)

grid.arrange(ggplot(data = final, aes(x = PC1, y = PC2, color = score)) +
               geom_point(size = 3) +
               theme_bw() +
               xlab("PC1") +
               ylab("PC2") +
               scale_color_gradient(low = "green", high = "red") +
               theme(plot.margin = unit(c(1,1,1,1), "cm")),
             ggplot(data = final, aes(x = PC1, y = PC3, color = score)) +
               geom_point(size = 3) +
               theme_bw() +
               xlab("PC1") +
               ylab("PC3") +
               scale_color_gradient(low = "green", high = "red") +
               theme(plot.margin = unit(c(1,1,1,1), "cm")),
             ncol = 2, nrow = 1)

grid.arrange(ggplot(data = final, aes(x = PC1, y = PC2, color = anom)) +
               geom_point(size = 3) +
               theme_bw() +
               xlab("PC1") +
               ylab("PC2") +
               scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) +
               theme(
                 plot.margin = unit(c(1,1,1,1), "cm"),
                 legend.text = element_text(face = "bold"),
                 legend.background = element_rect(fill = "lightgrey", size = 0.5, linetype = "solid", colour = "black")
               ) +
               labs(color = "Anomaly"),
             ggplot(data = final, aes(x = PC1, y = PC3, color = anom)) +
               geom_point(size = 3) +
               theme_bw() +
               xlab("PC1") +
               ylab("PC3") +
               scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) +
               theme(
                 plot.margin = unit(c(1,1,1,1), "cm"),
                 legend.text = element_text(face = "bold"),
                 legend.background = element_rect(fill = "lightgrey", size = 0.5, linetype = "solid", colour = "black")
               ) +
               labs(color = "Anomaly"),
             ncol = 2, nrow = 1)

grid.arrange(ggplot(data = final, aes(x = PC1, y = PC2)) +
               ggtitle("Information Density") +
               xlab("PC1") +
               ylab("PC2") +
               theme(panel.grid = element_blank(),
                     panel.background = element_blank(),
                     panel.border = element_rect(colour = "black", fill = NA),
                     axis.title = element_text(face = "bold"),
                     title = element_text(face = "bold"),
                     legend.background = element_rect(fill = NA,
                                                      size = 0.5, linetype = "solid", color = "black"),
                     legend.text = element_text(face = "italic"),
                     legend.title = element_text(face = "bold",
                                                 margin = margin(b = 5)),
                     plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm")
               ) +
               stat_density_2d(geom = "raster", aes(fill = after_stat(density)),
                               contour = FALSE) +
               scale_fill_continuous(type = "viridis") +
               labs(fill = "Density"),
             ggplot(data = final, aes(x = score)) +
               geom_vline(xintercept = 0.55, size = 0.5, colour = NA) +
               geom_vline(xintercept = threshold, size = 0.75, colour = "red") +
               geom_density(size = 1) +
               theme_bw() +
               labs(title = "Distribution of Anomaly Scores") +
               xlab("Anomaly Score") +
               ylab("Density") +
               theme(
                 plot.margin = unit(c(0.5,2,0.5,0.5), "cm"),
                 axis.title = element_text(face = "bold"),
                 title = element_text(face = "bold")
               ),
             ggplot(data = final, aes(x = PC1, y = PC2, color = anom)) +
               geom_vline(xintercept = 0, size = 0.5, linetype = "dashed") +
               geom_hline(yintercept = 0, size = 0.5, linetype = "dashed") +
               geom_point(size = 3) +
               theme_bw() +
               ggtitle("Final Classifications") +
               xlab("PC1") +
               ylab("PC2") +
               scale_color_manual(values = c("TRUE" = "red", "FALSE" = "black")) +
               theme(
                 plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"),
                 title = element_text(face = "bold"),
                 axis.title = element_text(face = "bold"),
                 legend.text = element_text(face = "italic"),
                 legend.title = element_text(face = "bold", margin = margin(b = 5)),
                 legend.background = element_rect(fill = NA, size = 0.5, linetype = "solid", colour = "black")
               ) +
               labs(color = "Anomaly"),
             ggplot(data = final, aes(x = PC1, y = PC2, color = score)) +
               geom_vline(xintercept = 0, size = 0.5, linetype = "dashed") +
               geom_hline(yintercept = 0, size = 0.5, linetype = "dashed") +
               geom_point(size = 3) +
               theme_bw() +
               xlab("PC1") +
               ylab("PC2") +
               ggtitle("Anomaly Scores") +
               scale_color_gradient(low = "green", high = "red") +
               theme(plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"),
                     axis.title = element_text(face = "bold"),
                     title = element_text(face = "bold"),
                     legend.background = element_rect(fill = NA,
                                                      size = 0.5, linetype = "solid", color = "black"),
                     legend.text = element_text(face = "italic"),
                     legend.title = element_text(face = "bold", margin = margin(b = 5))) +
               labs(color = "Anomaly Score"),
             nrow = 2, ncol = 2)

#

# Extract Final Cleaned Dataset -----------------------------

pc_scores <- final %>%
  filter(anom != "TRUE") %>%
  dplyr::select(-c(score, anom))

# Rescale values between -1 and 1

raw_data<-pc_scores %>% dplyr::select(-Sample)
raw_data<-ramify::mat(ReScale(ramify::flatten(as.matrix(raw_data),
                                              across = c("columns")), -1, 1),
                      ncol = ncol(raw_data), nrow = nrow(raw_data))
scaled_pc_scores<-data.frame(Sample = pc_scores$Sample, raw_data)
colnames(scaled_pc_scores)<-colnames(pc_scores)

#
