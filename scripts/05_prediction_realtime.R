# 05_prediction_realtime.R
library(keras)

# Load model
model <- load_model_hdf5("models/keras_model.h5")

# Read new batch
new_data <- read.csv("data/creditcard.csv")

# Select features (adapte selon ton modèle)
features <- as.matrix(new_data[, c("V1", "V2", "V3", "V4", "V5")])  # exemple

# Predict
predictions <- predict(model, features)

# Append predictions
new_data$predicted_fraud <- ifelse(predictions > 0.5, 1, 0)

# Save
write.csv(new_data, "outputs/predicted_batch.csv", row.names = FALSE)
