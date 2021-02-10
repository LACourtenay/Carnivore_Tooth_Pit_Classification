# Python Code by Lloyd A. Courtenay. Last Updated 10/02/2021
# Python Code for loading pretrained model weights

import os
os.chdir("") # Set Directory

# load libraries
import tensorflow as tf
from tensorflow.keras import backend
from tensorflow.keras.models import Model, Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import Dropout
from tensorflow.keras.layers import BatchNormalization, Activation, Dense
from tensorflow.keras.layers import Input
from tensorflow.keras.initializers import RandomNormal
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.regularizers import l2
from tensorflow.keras import backend as K
from tensorflow.keras.constraints import unit_norm
from tensorflow.keras.callbacks import *
from tensorflow.keras.wrappers.scikit_learn import KerasClassifier
from tensorflow.keras.layers.experimental import RandomFourierFeatures
import numpy as np

# Print package versions and ensure they have loaded correctly
print("Versions:")
print(f"Tensorflow {tf.__Version}")
print(f"Numpy {np.__Version}")

# Set random number generator
seed_value = 100
np.random.seed(seed_value)

# Define Swish Activation Function

def swish(x, beta = 1):
    return(x * K.sigmoid(beta * x))
from tensorflow.keras.utils import get_custom_objects
from tensorflow.keras.layers import Activation
get_custom_objects().update({"swish":Activation(swish)})

# Define NN Architecture

visible = Input(shape = (5,))
transform = RandomFourierFeatures(output_dim = 500,
                                  kernel_initializer = "laplacian",
                                  trainable = True,
                                  scale = 0.26) (visible)
batch_norm = BatchNormalization() (transform)
dropout = Dropout(0.5) (batch_norm)
hidden = Dense(250,
               activation = "swish",
               kernel_initializer = "random_normal",
               kernel_regularizer = l2(l = 0.0001)) (dropout)
batch_norm = BatchNormalization() (hidden)
dropout = Dropout(0.5) (batch_norm)
hidden = Dense(250,
               activation = "swish",
               kernel_initializer = "random_normal",
               kernel_regularizer = l2(l = 0.0001)) (dropout)
batch_norm = BatchNormalization() (hidden)
neural_model = Model(inputs = visible, outputs = batch_norm)

# Load Model Weights

neural_model.load_weights("Model.h5")
