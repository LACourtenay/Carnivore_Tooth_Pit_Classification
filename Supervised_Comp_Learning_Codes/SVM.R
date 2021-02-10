# R Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# R Code for Support Vector Machine Training and Bayesian Hyperparameter Optimization

# Necessary libraries and functions -----------------------------

# Libraries for training

library(caret)
library(e1071)

# Libraries for bayesian hyperparameter optimization

library(rBayesianOptimization)

# Function for train/test split

split.data = function(data,p = 0.7, s = 666) {
  set.seed(s)
  index = sample (1:dim(data)[1])
  train = data [index[1: floor(dim(data)[1]*p)],]
  test = data [index[((ceiling(dim(data)[1]*p)) + 1) :dim(data)[1]],]
  return(list(train = train, test = test))}

#

# Hyperparameter Optimization -----------------------------

# Make sure to load data with the name "a"
# e.g.
# a<-read.table(file.choose(), sep = ",", head = TRUE)

allset<-split.data(a, p = 0.8)
train<-allset$train
test<-allset$test

ctrl<-trainControl(method = "repeatedcv", repeats = 10)

# Random Hyperparameter Search Initialization

rand_ctrl<-trainControl(method = "repeatedcv", repeats = 10,
                        search = "random")
rand_search<-train(Sample ~ .,
                   data = train,
                   method = "svmRadial",
                   tuneLength = 10,
                   metric = "Accuracy",
                   #preProc = c("center", "scale"),
                   trControl = rand_ctrl); rand_search

# Bayesian Optimization

ctrl<-trainControl(method = "repeatedcv", repeats = 10)
svm_fit_bayes<-function(logC, logSigma) {
  txt<-capture.output(
    model<-train(Sample ~ .,
                 data = train,
                 method = "svmRadial",
                 metric = "Accuracy",
                 trControl = ctrl,
                 tuneGrid = data.frame(C = exp(logC),
                                       sigma = exp(logSigma)))
  )
  list(Score = getTrainPerf(model)[, "TrainAccuracy"], Pred = 0)
}
lower_bounds<-c(logC = -1, logSigma = -1)
upper_bounds<-c(logC = 7, logSigma = 7)
bounds<-list(logC = c(lower_bounds[1], upper_bounds[1]),
             logSigma = c(lower_bounds[2], upper_bounds[2]))
initial_grid <- rand_search$results[, c("C", "sigma", "Accuracy")]
initial_grid$C <- log(initial_grid$C)
initial_grid$sigma <- log(initial_grid$sigma)
initial_grid$Accuracy <- log(initial_grid$Accuracy)
names(initial_grid)<-c("logC", "logSigma", "Value")

ba_search<-BayesianOptimization(svm_fit_bayes,
                                bounds = bounds,
                                init_grid_dt = initial_grid,
                                init_points = 30,
                                n_iter = 10,
                                acq = "ei",
                                verbose = TRUE)

# Train Final Model -----------------------------

ctrl<-trainControl(method = "repeatedcv", repeats = 10,
                   classProbs = TRUE)
final_model<-svm(Sample~., data = train, kernel = "radial", type = "C",
                 cost = exp(ba_search$Best_Par["logC"]),
                 gamma = exp(ba_search$Best_Par["logSigma"]),
                 trControl = ctrl, probability = TRUE,
                 decision.values = TRUE)

svm.predict<-predict(final_model, test[, !names(test) %in% c("Sample")]) # Predict labels for test data
confusionMatrix(table(svm.predict, test$Sample))

#
