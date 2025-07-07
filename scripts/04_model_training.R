# 04_model_training.R
library(keras)

# Separate features and label
X <- scale(data[, !colnames(data) %in% c("Churn")])
Y <- data$Churn

# Build model
model <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(X)) %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  loss = "binary_crossentropy",
  optimizer = "adam",
  metrics = c("accuracy")
)

# Train model
model %>% fit(X, Y, epochs = 20, batch_size = 32, validation_split = 0.2)
save_model_hdf5(model, filepath = "app/models/keras_model.h5")