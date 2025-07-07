# 05_prediction_realtime.R
library(keras)
model <- load_model_hdf5("models/keras_model.h5")

# Simulated new data
new_data <- read.csv("data/streaming/data2.csv", stringsAsFactors = TRUE)

# Preprocessing
if ("customerID" %in% colnames(new_data)) new_data$customerID <- NULL
new_data$Churn <- NULL

categorical <- sapply(new_data, is.factor)
new_data[categorical] <- lapply(new_data[categorical], function(x) as.numeric(as.factor(x)))

X_new <- scale(new_data)
predictions <- predict(model, X_new)

new_data$Prediction <- ifelse(predictions > 0.5, "Churn", "No Churn")
write.csv(new_data, "outputs/predicted_batch.csv", row.names = FALSE)