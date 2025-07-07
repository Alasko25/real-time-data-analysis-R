# 01_load_data.R
data <- read.csv("data/data.csv", stringsAsFactors = TRUE)
str(data)
summary(data)

# Optional: remove customerID
if ("customerID" %in% colnames(data)) {
  data$customerID <- NULL
}

# Convert target variable to binary numeric
if ("Churn" %in% colnames(data)) {
  data$Churn <- ifelse(data$Churn == "Yes", 1, 0)
}

# Encode categorical variables
categorical <- sapply(data, is.factor)
data[categorical] <- lapply(data[categorical], function(x) as.numeric(as.factor(x)))
