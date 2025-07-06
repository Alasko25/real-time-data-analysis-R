library(keras)

# Normalisation
X <- scale(data[, -ncol(data)])
Y <- data$target

model <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = ncol(X)) %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 1)

model %>% compile(
  loss = "mse",
  optimizer = "adam",
  metrics = c("mae")
)

model %>% fit(X, Y, epochs = 50, batch_size = 32, validation_split = 0.2)
save_model_hdf5(model, filepath = "models/keras_model.h5")
